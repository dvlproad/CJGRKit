//
//  CJImageAdjustGRView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//

#import "CJImageAdjustGRView.h"
#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJKeepCoveredBounds.h>
#import <CJGRKit/CGRectCJSubHelper.h>

@interface CJImageAdjustGRView ()

@property (nonatomic, assign) BOOL didSetupOnce;

@end

@implementation CJImageAdjustGRView

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _cropRatio = 1.0;           // 默认 1:1 裁剪窗口
        _cropRectCoversBounds = YES; // 默认裁剪窗口盖满整个编辑区（图片拼接主场景）
        _maxScale = 6.0;            // 对齐 CJGR 默认最大缩放
        _keepCoveredEnabled = YES;  // 默认开启裁剪窗口约束（吸附）
        
        self.backgroundColor = backgroundColor;
        self.layer.masksToBounds = YES; // 超出编辑区部分截掉
        
        // 内容：图片本身（第一公民），开启交互作手势载体
        UIImageView *contentView = [[UIImageView alloc] init];
        contentView.userInteractionEnabled = YES;   // UIImageView 默认 NO，手势载体须开启
        contentView.contentMode = UIViewContentModeScaleAspectFill;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        _contentView = contentView;
        
        // 内置手势：拖动 + 捏合（正交独立，加在内容上）
        contentView.cjGRMaxScale = self.maxScale;
        [contentView cj_addPanGR];
        [contentView cj_addPinchGR];
        
        // 内置手势状态观察（与 KeepCovered 吸附回调并存互不覆盖）：
        // 先走子类扩展 hook，再转发给宿主 grStateChangeBlock
        __weak typeof(self) weakSelf = self;
        contentView.cjGRStateChangeBlock2 = ^(CJGRType type, UIGestureRecognizerState state) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            // 手势结束：触发裁剪窗口约束吸附（KeepCoveredBounds 不再自动感知手势，由外部接线）
            if (state == UIGestureRecognizerStateEnded ||
                state == UIGestureRecognizerStateCancelled) {
                [strongSelf.contentView cj_keepCoveredAdsorb];
            }
            [strongSelf __handleGRState:type state:state];
            !strongSelf.grStateChangeBlock ?: strongSelf.grStateChangeBlock(type, state);
        };
    }
    return self;
}

// 兜底：裸 init / initWithFrame: 也返回完整配置的组件（默认黑底），避免静默得到未配置视图
- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithBackgroundColor:[UIColor blackColor]];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self __refreshMask];
    
    if (self.didSetupOnce) {
        return;
    }
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    self.didSetupOnce = YES;
    
    // 裁剪窗口未手动设置时生成：盖满编辑区 或 按 cropRatio 生成居中最大窗口
    if (self.keepCoveredEnabled && CGRectIsEmpty(self.cropRect)) {
        if (self.cropRectCoversBounds) {
            self.cropRect = self.bounds;
        } else {
            self.cropRect = [CGRectCJSubHelper getMaxSubFrameWithRatio:self.cropRatio
                                                           inCageFrame:self.bounds
                                                       subFramePositon:YES];
        }
    }
    
    // 内容覆盖裁剪窗口 + 手势结束吸附
    if (self.keepCoveredEnabled && !CGRectIsEmpty(self.cropRect)) {
        [self.contentView cj_setKeepCoveredRect:self.cropRect];
    }
    
    // 初始内容布局
    [self updateFrameByImage:self.contentView.image];
}

#pragma mark - set
- (void)setImage:(UIImage *)image {
    _image = image;
    self.contentView.image = image;
    [self updateFrameByImage:image];
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    [self __refreshMask];
    if (!CGRectIsEmpty(cropRect) && self.keepCoveredEnabled) {
        [self.contentView cj_setKeepCoveredRect:cropRect];
    }
}

- (void)setCropRatio:(CGFloat)cropRatio {
    if (cropRatio <= 0) {
        cropRatio = 1.0;   // 非法比例兜底为 1:1
    }
    _cropRatio = cropRatio;
    if (!self.didSetupOnce || !self.keepCoveredEnabled || CGRectIsEmpty(self.bounds)) {
        return;
    }
    self.cropRect = [CGRectCJSubHelper getMaxSubFrameWithRatio:self.cropRatio
                                                   inCageFrame:self.bounds
                                               subFramePositon:YES];
    // 按新窗口重置内容布局（覆盖并居中，重置缩放）
    [self updateFrameByImage:self.contentView.image];
}

- (void)setKeepCoveredEnabled:(BOOL)keepCoveredEnabled {
    _keepCoveredEnabled = keepCoveredEnabled;
    self.contentView.cjKeepCoveredEnabled = keepCoveredEnabled;  // 关=停止吸附，开=恢复吸附
    if (keepCoveredEnabled && !CGRectIsEmpty(self.cropRect)) {
        [self.contentView cj_setKeepCoveredRect:self.cropRect];
    }
}

- (void)setMaxScale:(CGFloat)maxScale {
    _maxScale = maxScale;
    self.contentView.cjGRMaxScale = maxScale;
}

#pragma mark - 子类扩展 hooks
/// 刷新裁剪窗口（基类空实现；蒙层子类覆写为绘制镂空路径/白边）
- (void)__refreshMask {
}

/// 手势状态扩展（基类空实现；蒙层子类覆写为拖动中显示被遮挡区域）
- (void)__handleGRState:(CJGRType)type state:(UIGestureRecognizerState)state {
}

#pragma mark - 内容操作
/// 保持图片比例、覆盖裁剪窗口并居中（重置缩放）
- (void)updateFrameByImage:(UIImage *)image {
    if (image == nil) {
        return;
    }
    CGRect coverRect = CGRectIsEmpty(self.cropRect) ? self.bounds : self.cropRect;
    if (CGRectIsEmpty(coverRect)) {
        return;
    }
    
    CGFloat minShowFrameRatio = image.size.width/image.size.height; // 保持图片宽高比
    CGRect minShowFrame = [CGRectCJSubHelper getMinSubFrameWithRatio:minShowFrameRatio
                                                            minWidth:CGRectGetWidth(coverRect)
                                                           minHeight:CGRectGetHeight(coverRect)
                                                         inCageFrame:self.bounds
                                                     subFramePositon:YES];
    // 用 bounds+center 设置（与 transform 缩放解耦），再重置缩放
    self.contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(minShowFrame), CGRectGetHeight(minShowFrame));
    self.contentView.center = CGPointMake(CGRectGetMidX(coverRect), CGRectGetMidY(coverRect));
    [self.contentView cj_setGRScale:1];
}

/// 裁剪窗口对应的图片像素区域（供真正裁剪）
- (CGRect)getClippingPixelRect {
    UIImage *image = self.contentView.image;
    if (image == nil || CGRectIsEmpty(self.cropRect)) {
        return CGRectZero;
    }
    // 窗口在内容坐标系中相对内容渲染 frame 原点的偏移
    CGRect contentRect = self.contentView.frame;
    CGRect overlapLocal = CGRectMake(self.cropRect.origin.x - contentRect.origin.x,
                                     self.cropRect.origin.y - contentRect.origin.y,
                                     self.cropRect.size.width, self.cropRect.size.height);
    if (CGRectGetWidth(contentRect) == 0) {
        return CGRectZero;
    }
    // 每渲染 pt 对应的图片像素数（含 transform 缩放与 image.scale 倍率）
    CGFloat pixelPerPt = image.size.width * image.scale / CGRectGetWidth(contentRect);
    CGRect pixelRect = CGRectMake(overlapLocal.origin.x * pixelPerPt,
                                  overlapLocal.origin.y * pixelPerPt,
                                  overlapLocal.size.width * pixelPerPt,
                                  overlapLocal.size.height * pixelPerPt);
    return pixelRect;
}

@end
