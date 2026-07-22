//
//  CJGRView.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "CJGRView.h"
#import "CGRectCJAdjustHelper.h"

@interface CJGRView () {
    
}
@property (nonatomic, copy, readonly) void(^ _Nullable panStateChangeBlock)(UIGestureRecognizerState panGRState);                  /**< 拖动状态发生改变的回调 */
@property (nonatomic, copy, readonly) void(^ _Nullable pinchStateChangeBlock)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale);  /**< 捏合缩放状态发生改变的回调 */

@end

@implementation CJGRView

/*
 *  初始化
 *
 *  @param subViewCreateBlock       用来展示缩放拖动效果的视图的创建
 *  @param panStateChangeBlock      拖动状态发生改变的回调
 *  @param pinchStateChangeBlock    捏合缩放状态发生改变的回调
 *
 *  @return 可缩放子视图的视图
 */
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                       panStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState panGRState))panStateChangeBlock
                     pinchStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale))pinchStateChangeBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _panStateChangeBlock = panStateChangeBlock;
        _pinchStateChangeBlock = pinchStateChangeBlock;
        self.layer.masksToBounds = YES; // 超出视图部分截掉
        
        NSAssert(subViewCreateBlock != nil, @"用来展示缩放拖动效果的视图的创建方法不能为空");
        UIView *scaleShowView = subViewCreateBlock();
        [self addSubview:scaleShowView];
        _scaleShowView = scaleShowView;
        
        //scaleShowView.backgroundColor = [UIColor purpleColor];
        //[scaleShowView setFrame:CGRectMake(10, 10, 100, 100)];
        
        [self addPanAndPinGesture];
    }
    return self;
}

/*
 *  设置【用来展示缩放拖动效果的视图】在未进行任何拖动或捏合前的原始frame
 *
 *  @param scaleShowViewOriginFrame     未进行任何拖动或捏合前的原始frame
 */
- (void)updateScaleShowViewOriginFrame:(CGRect)scaleShowViewOriginFrame {
    NSAssert(scaleShowViewOriginFrame.size.width != 0 && scaleShowViewOriginFrame.size.height != 0, @"设置的大小不能为0");
    _scaleShowViewOriginFrame = scaleShowViewOriginFrame;
    _hasSetFrameForThisImage = YES;
    
    [self.scaleShowView setFrame:scaleShowViewOriginFrame];
}

- (void)updateFrameByImage:(UIImage *)image {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width == 0 || height == 0) {
        //NSLog(@"视图宽高还未渲染出来");
        return;
    }
    
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height; // 图片的宽高比
    CGFloat imageWidth  = width;
    CGFloat imageHeight = imageWidth/imageWidthHeightRatio;
    
    CGFloat imageOriginX = width/2 - imageWidth/2;
    CGFloat imageOriginY = height/2 - imageHeight/2;
    CGRect scaleShowViewOriginFrame = CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight);
    [self updateScaleShowViewOriginFrame:scaleShowViewOriginFrame];
}


#pragma mark 添加手势
- (void)addPanAndPinGesture {
    //捏合手势
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinGesture];
    
    //拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
}



// 捏合/缩放视图
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGR
{
    CGFloat relativeLastScale = pinchGR.scale;
    //NSLog(@"本次相对上次的缩放倍数pinchGR.scale=%.4f", relativeLastScale);
    
    CGRect scaleShowViewOriginFrame = self.scaleShowViewOriginFrame;
    CGRect scaleShowViewCurrentFrame = self.scaleShowView.frame;
    CGFloat willWidth = CGRectGetWidth(scaleShowViewCurrentFrame) * pinchGR.scale;  // 本次如果缩放后，宽度将变为的值
    CGFloat willPinchScale = willWidth / CGRectGetWidth(scaleShowViewOriginFrame);  // 如果变化后，新值和原始值的比例
    //NSLog(@"如果变化后，新值和原始值的捏合倍数为willPinchScale=%.4f", willPinchScale);
    

    CGFloat oldPinchScale =  CGRectGetWidth(scaleShowViewCurrentFrame) / CGRectGetWidth(scaleShowViewOriginFrame);
    //NSLog(@"未捏合前的缩放倍数为oldPinchScale=%.4f", oldPinchScale);

    
    CGFloat newPinchScale = [self newScaleByWillToPinchScale:willPinchScale fromOldPinchScale:oldPinchScale pinchGRState:pinchGR.state];
    BOOL needChangePinchScale = newPinchScale != oldPinchScale;
    
    
    if(pinchGR.state == UIGestureRecognizerStateBegan ||
       pinchGR.state == UIGestureRecognizerStateChanged)
    {
        if (needChangePinchScale == YES) {
            CGAffineTransform currentTransform = self.scaleShowView.transform;
            self.scaleShowView.transform = CGAffineTransformScale(currentTransform, pinchGR.scale, pinchGR.scale);
            pinchGR.scale = 1.0;
        } else {
            NSLog(@"提示：无法从%.4f变化到指定倍数%.4f", oldPinchScale, willPinchScale);
        }
        
    } else if (pinchGR.state == UIGestureRecognizerStateEnded) {
        
    }
    
    
    
    !self.pinchStateChangeBlock ?: self.pinchStateChangeBlock(pinchGR.state, willPinchScale);
}

/*
 *  获取最新要缩放到的倍数（如果返回oldPinchScale，则不用进行多余的缩放）
 *
 *  @param willToPinchScale     是否可以缩放到的倍数
 *  @param oldPinchScale        当前的缩放倍数
 *  @param pinchGRState     捏合的手势状态
 *
 *  @return     最新要缩放到的倍数
 */
- (CGFloat)newScaleByWillToPinchScale:(CGFloat)willToPinchScale
                    fromOldPinchScale:(CGFloat)oldPinchScale
                         pinchGRState:(UIGestureRecognizerState)pinchGRState
{
    return willToPinchScale;
}

/// 拖动手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if(panGesture.state == UIGestureRecognizerStateBegan ||
       panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self.scaleShowView.superview];
        [self.scaleShowView setCenter:CGPointMake(self.scaleShowView.center.x + translation.x, self.scaleShowView.center.y + translation.y)];
        
        [panGesture setTranslation:CGPointZero inView:self.scaleShowView.superview];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
//        [self panEndtoClippingFrame:self.circularFrame]; //TODO:
        
    }
    
    !self.panStateChangeBlock ?: self.panStateChangeBlock(panGesture.state);
}



// 捏合/缩放结束
- (void)pinEndWithMaxScaleRation:(CGFloat)maxScaleRation
                 toClippingFrame:(CGRect)clippingFrame
{
    CGFloat pinchScale =  self.scaleShowView.frame.size.width /self.scaleShowViewOriginFrame.size.width;
    
    if(pinchScale > maxScaleRation) { // 缩放倍数 > 自定义的最大倍数
        pinchScale = maxScaleRation;
        
        CGFloat originWidth = CGRectGetWidth(self.scaleShowViewOriginFrame);
        CGFloat originHeight = CGRectGetHeight(self.scaleShowViewOriginFrame);
        CGFloat newWidth = originWidth * pinchScale;
        CGFloat newHeight = originHeight * pinchScale;
        __block CGRect newFrame = CGRectMake(0, 0, newWidth, newHeight);
        [UIView animateWithDuration:0.05 animations:^{
            newFrame = CGRectMake(100, 100, 100, 100);
            [self.scaleShowView setFrame:newFrame];
        }];
    } else {
        [self adjustToClippingFrame:clippingFrame];
    }
}

/// 根据裁剪框clippingFrame修正/限制scaleShowView的size大小，并同时根据clippingFrame的边框来进行吸附
- (void)adjustToClippingFrame:(CGRect)clippingFrame {
    CGRect currentFrame = self.scaleShowView.frame;
    CGRect newFrame = [CGRectCJAdjustHelper adjustCageFrame:currentFrame
                                      accordingToSmallFrame:clippingFrame
                                             adjustCageSize:YES
                                               adjustCageXY:YES];
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scaleShowView setFrame:newFrame];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
