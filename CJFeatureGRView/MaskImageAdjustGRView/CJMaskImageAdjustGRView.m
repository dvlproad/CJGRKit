//
//  CJMaskImageAdjustGRView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//

#import "CJMaskImageAdjustGRView.h"

@interface CJMaskImageAdjustGRView ()

@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;   // 镂空内容层：黑色 even-odd 绘制框外区域
@property (nonatomic, strong) UIView *cropBorderView;         // 裁剪窗口白边标记（拖动时显示）

@end

@implementation CJMaskImageAdjustGRView

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor {
    self = [super initWithBackgroundColor:backgroundColor];
    if (self) {
        self.cropRectCoversBounds = NO; // 裁剪场景：裁剪窗口按 cropRatio(默认1:1) 生成，不盖满编辑区
        _shapeType = CJRectPathTypeRectangle;
        _restMaskOpacity = 1.0;    // 默认框外隐藏
        
        // 蒙层：镂空内容层（黑色 even-odd 绘制框外区域）+ 窗口白边标记
        CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
        maskShapeLayer.fillRule = kCAFillRuleEvenOdd;
        maskShapeLayer.fillColor = [UIColor blackColor].CGColor;
        maskShapeLayer.opacity = self.restMaskOpacity;
        [self.layer addSublayer:maskShapeLayer];
        _maskShapeLayer = maskShapeLayer;
        
        UIView *cropBorderView = [[UIView alloc] init];
        cropBorderView.backgroundColor = [UIColor clearColor];
        cropBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
        cropBorderView.layer.borderWidth = 0;
        cropBorderView.userInteractionEnabled = NO;
        [self addSubview:cropBorderView];
        _cropBorderView = cropBorderView;
    }
    return self;
}

#pragma mark - set
- (void)setShapeType:(CJRectPathType)shapeType {
    _shapeType = shapeType;
    [self __refreshMask];
}

- (void)setRestMaskOpacity:(CGFloat)restMaskOpacity {
    _restMaskOpacity = restMaskOpacity;
    self.maskShapeLayer.opacity = restMaskOpacity;  // 立即生效（非拖动态）
}

#pragma mark - 蒙层
- (void)showOther:(BOOL)show {
    self.maskShapeLayer.opacity = show ? 0.4 : self.restMaskOpacity;
    self.cropBorderView.layer.borderWidth = show ? 0.5 : 0;
}

/// 刷新镂空路径与白边标记（cropRect 为 self.bounds 坐标系；基类 hook 覆写）
- (void)__refreshMask {
    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds) || CGRectIsEmpty(self.cropRect)) {
        self.maskShapeLayer.path = nil;
        self.cropBorderView.frame = CGRectZero;
        return;
    }
    self.maskShapeLayer.frame = bounds; // 蒙层层 frame 对齐编辑区，保证路径坐标系一致
    
    // 镂空路径：outer 全区域 + hole 裁剪窗口（矩形/圆形）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    UIBezierPath *clearPath = [UIBezierPathCJHelper bezierPathForRectFrame:self.cropRect pathType:self.shapeType];
    [path appendPath:clearPath];
    [path setUsesEvenOddFillRule:YES];
    self.maskShapeLayer.path = path.CGPath;
    
    // 裁剪窗口白边标记（圆形预览 → 白边变圆）
    self.cropBorderView.frame = self.cropRect;
    self.cropBorderView.layer.cornerRadius = (self.shapeType == CJRectPathTypeCircle) ? CGRectGetWidth(self.cropRect)/2 : 0;
}

/// 手势联动：拖动进行中显示被遮挡区域，结束恢复（基类 hook 覆写）
- (void)__handleGRState:(CJGRType)type state:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateBegan) {
        [self showOther:YES];
    } else if (state == UIGestureRecognizerStateEnded ||
               state == UIGestureRecognizerStateCancelled) {
        [self showOther:NO];
    }
}

@end
