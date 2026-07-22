//
//  CJImageNormalAdjustGRView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//
//  图片普通调整（缩放、拖动）视图，没有裁剪框。场景：如图片拼接里的位置、大小调整。
//  为更好使用，请继承并根据要求调用updateFrameByImage方法（附：本类里面已重写 layoutSubviews）

#import "CJAdjustGRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJImageNormalAdjustGRView : CJAdjustGRView {
    
}
@property (nonatomic, strong) UIImage *image;   // 要裁剪的图片（请在 init 后设置)

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

@end

NS_ASSUME_NONNULL_END
