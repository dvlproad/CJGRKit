//
//  CJGRView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//
//  自定义的形同 UIScrollView 能够进行拖动和缩放的视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class CJGRView;
//@protocol CJGRViewDelegate <NSObject>
//
//@optional
///// 捏合手势状态变化
//- (void)cjGRView_pinch:(CJGRView *)grView grStateChange:(UIGestureRecognizerState)pinchGRState;
//
///// 拖动手势状态变化
//- (void)cjGRView_pan:(CJGRView *)grView grStateChange:(UIGestureRecognizerState)panGRState;
//
//- (CGFloat)cjGRView_pinchMaxScale;
//
//@end




@interface CJGRView : UIView {
    
}
@property (nonatomic, strong, readonly) UIView *scaleShowView;      /**< 用来展示缩放拖动效果的视图（一般是UIImageView） */

@property (nonatomic, assign, readonly) CGRect scaleShowViewOriginFrame;/**< 未进行任何拖动或捏合前的原始frame */
@property (nonatomic, assign, readonly) BOOL hasSetFrameForThisImage;   /**< 是否已经为此图片设置过frame（更新图片的是否会充值此属性为NO） */

#pragma mark - Init
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
                     pinchStateChangeBlock:(void(^ _Nullable)(UIGestureRecognizerState pinchGRState, CGFloat pinchScale))pinchStateChangeBlock NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

#pragma mark - 其他限制
- (void)configClippingFrame:(CGRect)clippingFrame shouldAdsorb:(BOOL)shouldAdsorb;

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
                         pinchGRState:(UIGestureRecognizerState)pinchGRState;


/*
 *  设置【用来展示缩放拖动效果的视图】在未进行任何拖动或捏合前的原始frame
 *
 *  @param scaleShowViewOriginFrame     未进行任何拖动或捏合前的原始frame
 */
- (void)updateScaleShowViewOriginFrame:(CGRect)scaleShowViewOriginFrame;

@end

NS_ASSUME_NONNULL_END
