//
//  CJImageNormalAdjustGRView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//
//  常见缩放调整视图：为更好使用，请继承并根据要求调用updateFrameByImage方法（附：本类里面已重写 layoutSubviews）

#import "CJAdjustGRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJImageNormalAdjustGRView : CJAdjustGRView {
    
}

#pragma mark - Init
/*
 *  初始化
 *
 *  @param contentMode  contentMode
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithContentMode:(UIViewContentMode)contentMode NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_UNAVAILABLE;


#pragma mark - Update
/*
 *  根据得到的图片，在保持其比例的情况下，更新图片所占的frame（请在每次得到图片的时候调用此方法）
 *
 *  @param image 通过imageName或imageUrl等得到的图片
 */
- (void)updateFrameByImage:(UIImage *)image;

#pragma mark - Get
- (UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
