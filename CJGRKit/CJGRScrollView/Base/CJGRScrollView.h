//
//  CJGRScrollView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CJGRScrollView;
@protocol CQGRScrollViewDelegate <NSObject>

/** 单击事件 */
- (void)singleTapAction;

/** 退出事件 */
- (void)dismissActionAtCollectionViewCell:(CJGRScrollView *)cell;

/** 长按事件 */
- (void)longPressActionAtCollectionViewCell:(CJGRScrollView *)cell;

@end




@interface CJGRScrollView : UIScrollView <UIScrollViewDelegate> {
    
}
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong, readonly) UIView *scaleShowView;      /**< 用来展示缩放拖动效果的视图（一般是UIImageView） */

/**< 最大的缩放倍数（默认0，即不限制缩放） */
@property (nonatomic, assign) CGFloat pinchMaxScale;

/** 代理 */
//@property (weak, nonatomic) id<CQGRScrollViewDelegate> delegate;

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
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
