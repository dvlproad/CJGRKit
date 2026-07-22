//
//  CJAdjustGRView.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//

#import "CJAdjustGRView.h"
#import "CGRectCJAdjustHelper.h"

@interface CJAdjustGRView () {
    
}
@property (nonatomic, copy, readonly) UIView *(^ _Nullable clippingViewCreateBlock)(void);  /**< 裁剪框的创建(可以为nil) */


// 以下两个block的命名避免与父类的block命令一样
@property (nonatomic, copy, readonly) void(^ _Nullable panStateChangeBlock2)(UIGestureRecognizerState panGRState);                  /**< 拖动状态发生改变的回调 */
@property (nonatomic, copy, readonly) void(^ _Nullable pinchStateChangeBlock2)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale);  /**< 捏合缩放状态发生改变的回调 */

@end

@implementation CJAdjustGRView

#pragma mark - Init
/*
 *  初始化
 *
 *  @param subViewCreateBlock       用来展示缩放拖动效果的视图的创建（不可以为nil）
 *  @param clippingViewCreateBlock  裁剪框的创建(可以为nil)
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock
{
    self = [super initWithSubViewCreateBlock:subViewCreateBlock panStateChangeBlock:^(UIGestureRecognizerState panGRState) {
        if(panGRState == UIGestureRecognizerStateBegan) {
            //NSLog(@"拖动Pan开始");
        } else if (panGRState == UIGestureRecognizerStateChanged) {
            //NSLog(@"拖动Pan变化中");
        } else if (panGRState == UIGestureRecognizerStateEnded) {
            //NSLog(@"拖动Pan结束");
            if (CGRectEqualToRect(self.clippingFrame, CGRectZero)) {
                NSLog(@"当前未限制移动范围clippingFrame，则可任意移动");
            } else {
                [self adjustShowViewAccordingToClippingFrame:self.clippingFrame];
            }
        }
        !self.panStateChangeBlock2 ?: self.panStateChangeBlock2(panGRState);
        
    } pinchStateChangeBlock:^(UIGestureRecognizerState pinchGRState, CGFloat pinchScale) {
        if(pinchGRState == UIGestureRecognizerStateBegan) {
            //NSLog(@"捏合缩放Pinch开始");
        } else if (pinchGRState == UIGestureRecognizerStateChanged) {
            //NSLog(@"捏合缩放Pinch变化中");
            
        } else if (pinchGRState == UIGestureRecognizerStateEnded) {
            //NSLog(@"捏合缩放Pinch结束");
            [self checkPinchScale:pinchScale];
        }

        !self.pinchStateChangeBlock2 ?: self.pinchStateChangeBlock2(pinchGRState, pinchScale);
    }];
    if (self) {
        _clippingViewCreateBlock = clippingViewCreateBlock;
        
        if (clippingViewCreateBlock != nil) {
            UIView *clippingRegionView = clippingViewCreateBlock();
            //clippingRegionView.backgroundColor = [UIColor redColor];
            //clippingRegionView.alpha = 0.5;
            [self addSubview:clippingRegionView];
            _clippingRegionView = clippingRegionView;
        }
    }
    return self;
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
//    if (pinchGRState == UIGestureRecognizerStateChanged) {
        if (self.controlMaxScaleOnPinchChanging && willToPinchScale > 1 && self.pinchMaxScale > 1) {
            // ①当前是放大，②当前有有限制最大放大倍数，③在pinch捏合手势变化的过程中就进行最大倍数的限制
            if (willToPinchScale > self.pinchMaxScale) {   // 缩放倍数 > 自定义的最大倍数
                return oldPinchScale;
            }
        }
//    }
    
    return willToPinchScale;
}

- (void)checkPinchScale:(CGFloat)pinchScale {
    //NSLog(@"当前缩放倍数为%.2f, 而允许的最大倍数是%.2f", pinchScale, self.pinchMaxScale);
    if (self.pinchMaxScale > 1 && pinchScale > self.pinchMaxScale) {   // 有限制最大放大倍数，且缩放倍数 > 自定义的最大倍数
        [self enlargeToScale:self.pinchMaxScale animateWithDuration:0.0 completion:nil];
    } else {
        [self __checkFrame];
    }
}


#pragma mark - Config
/*
 *  设置拖动和捏合缩放等手势状态发生变化的回调(内部已处理完位置调整等操作)
 *
 *  @param panStateChangeBlock          拖动状态发生改变的回调
 *  @param pinchStateChangeBlock        捏合缩放状态发生改变的回调
 */
- (void)setupExtraPanStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState panGRState))panStateChangeBlock
                pinchStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale))pinchStateChangeBlock
{
    _panStateChangeBlock2 = panStateChangeBlock;
    _pinchStateChangeBlock2 = pinchStateChangeBlock;
}

#pragma mark - Setter
- (void)setClippingFrame:(CGRect)clippingFrame {
    _clippingFrame = clippingFrame;
    
    if (self.clippingRegionView) {
        [self.clippingRegionView setFrame:clippingFrame];
    }
}

#pragma mark - Getter
/*
 *  获取scaleShowView的frame与裁剪区域clippingFrame相交/重叠的那部分frame：使用场景图片裁剪
 *
 *  @return 与裁剪区域clippingFrame相交/重叠的那部分显示视图frame
 */
- (CGRect)getOverlappingShowFrame {
    UIView *scaleShowView = self.scaleShowView;
    CGRect clipRect = self.clippingFrame;
    
    CGFloat width = scaleShowView.frame.size.width;
    
    CGFloat origX = (clipRect.origin.x - scaleShowView.frame.origin.x);
    CGFloat origY = (clipRect.origin.y - scaleShowView.frame.origin.y);
    CGFloat oriWidth = clipRect.size.width;
    CGFloat oriHeight = clipRect.size.height;
  
    CGRect overlappingShowFrame = CGRectMake(origX, origY, oriWidth, oriHeight);
    return overlappingShowFrame;
}

#pragma mark - Event
/*
 *  从原始大小(不是从当前大小)缩放视图到指定倍数
 *
 *  @param pinchScale   要缩放的倍数
 *  @param duration     动画持续时间
 *  @param completion   动画结束的回调
 */
- (void)enlargeToScale:(CGFloat)pinchScale animateWithDuration:(NSTimeInterval)duration completion:(void (^ __nullable)(BOOL finished))completion {
    //NSLog(@"执行缩放到指倍数%.2f", pinchScale);
    CGFloat originWidth = CGRectGetWidth(self.scaleShowViewOriginFrame);
    CGFloat originHeight = CGRectGetHeight(self.scaleShowViewOriginFrame);
    CGFloat newCageWidth = originWidth * pinchScale;
    CGFloat newCageHeight = originHeight * pinchScale;
    
    
    CGRect cageFrame = self.scaleShowView.frame;
    
    // 保持中心不变，得到调整大小后的cage的区域
    CGPoint currentCageCenter = CGPointMake(CGRectGetMidX(cageFrame), CGRectGetMidY(cageFrame)); // 未调整前的cage中心
    CGFloat newCageOriginX = currentCageCenter.x - newCageWidth/2;
    CGFloat newCageOriginY = currentCageCenter.y - newCageHeight/2;
    CGRect newCageFrame = CGRectMake(newCageOriginX, newCageOriginY, newCageWidth, newCageHeight);
    //newCageFrame = CGRectMake(100, 100, 100, 100);
    
    [UIView animateWithDuration:duration animations:^{
        NSLog(@"newCageFrame = %@", NSStringFromCGRect(newCageFrame));
        [self.scaleShowView setFrame:newCageFrame];
    } completion:^(BOOL finished) {
        // 放大后，可能进行移动，移动完，再慢慢缩小回来，位置就变了，所以还是得进行位置调整
        [self __checkFrame];
        !completion ?: completion(finished);
    }];
    
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
//    self.transform = transform; // 不要使用transform方法，其会使得整个视图的框放大，而不是内部变大
}


#pragma mark - Private Method
// 任何位置变化都要执行frame位置检查。即使是放大后，也可能进行移动，然后当移动完，再慢慢缩小回来，此时缩小回来位置就变了，所以还是得进行位置调整
- (void)__checkFrame {
    if (CGRectEqualToRect(self.clippingFrame, CGRectZero)) {
        NSLog(@"当前未限制移动范围clippingFrame，则可任意移动");
    } else {
        [self adjustShowViewAccordingToClippingFrame:self.clippingFrame];
    }
}

/*
 *  调整图片区域使其能包住裁剪框smallFrame
 *
 *  @param smallFrame       裁剪框区域
 *
 *  @return 调整图片区域后的新frame
 */
- (void)adjustShowViewAccordingToClippingFrame:(CGRect)smallFrame {
    CGRect cageFrame = self.scaleShowView.frame;
    CGRect newCageFrame = [CGRectCJAdjustHelper adjustCageFrame:cageFrame
                                          accordingToSmallFrame:smallFrame
                                                 adjustCageSize:YES
                                                   adjustCageXY:YES];
    
    [UIView animateWithDuration:0.05 animations:^{
        [self.scaleShowView setFrame:newCageFrame];
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
