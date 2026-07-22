//
//  CJImageGRScrollView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/3.
//

#import "CJGRScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJImageGRScrollView : CJGRScrollView {
    
}
@property (nonatomic, strong) UIImage *image;   // 要裁剪的图片（请在 init 后设置)
@property (nonatomic, assign, readonly) CGRect scaleShowViewOriginFrame;/**< 未进行任何拖动或捏合前的原始frame */
@property (nonatomic, assign, readonly) BOOL hasSetFrameForThisImage;   /**< 是否已经为此图片设置过frame（更新图片的是否会充值此属性为NO） */

#pragma mark - Init
/*
 *  初始化
 *
 *  @param contentMode  contentMode
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithContentMode:(UIViewContentMode)contentMode;
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_UNAVAILABLE;

#pragma mark - Get
- (UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
