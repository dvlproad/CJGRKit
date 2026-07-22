//
//  CJAdjustGRView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//
//  在【自定义的形同 UIScrollView 能够进行拖动和缩放的视图】的基础上【增加可限制拖动范围】

#import "CJGRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJAdjustGRView : CJGRView {
    
}
@property (nullable, nonatomic, strong, readonly) UIView *clippingRegionView;   /**< 裁剪框视图（可以为nil） */


/**< 裁剪框的位置（拖动时候用来限制范围，缩放时候用来限制大小，默认CGRectZero，即不限制） */
@property (nonatomic, assign) CGRect clippingFrame;

/**< 最大的缩放倍数（默认0，即不限制缩放），目前设置此值后，如果一直放大的时候，会导致图片没掉，请使用controlMaxScaleOnPinchChanging=YES来临时修复 */
@property (nonatomic, assign) CGFloat pinchMaxScale;
/**< 在pinch捏合手势变化的过程中就进行最大倍数的限制（默认NO，在捏合结束才判断，此参数设为YES目前用于临时修复一直放大时候图片会没掉的问题） */
@property (nonatomic, assign) BOOL controlMaxScaleOnPinchChanging;


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
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                       panStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState panGRState))panStateChangeBlock
                     pinchStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale))pinchStateChangeBlock NS_UNAVAILABLE;


#pragma mark - Config
/*
 *  设置拖动和捏合缩放等手势状态发生变化的回调(内部已处理完位置调整等操作)
 *
 *  @param panStateChangeBlock          拖动状态发生改变的回调
 *  @param pinchStateChangeBlock        捏合缩放状态发生改变的回调
 */
- (void)setupExtraPanStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState panGRState))panStateChangeBlock
                pinchStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale))pinchStateChangeBlock;


#pragma mark - Getter
/*
 *  获取scaleShowView的frame与裁剪区域clippingFrame相交/重叠的那部分frame：使用场景图片裁剪
 *
 *  @return 与裁剪区域clippingFrame相交/重叠的那部分显示视图frame
 */
- (CGRect)getOverlappingShowFrame;

#pragma mark - Event
/*
 *  从原始大小(不是从当前大小)缩放视图到指定倍数
 *
 *  @param pinchScale   要缩放的倍数
 *  @param duration     动画持续时间
 *  @param completion   动画结束的回调
 */
- (void)enlargeToScale:(CGFloat)pinchScale animateWithDuration:(NSTimeInterval)duration completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
