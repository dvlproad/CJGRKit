//
//  CJImageClipAdjustGRView.h
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//
//
//  图片裁剪调整（缩放、拖动）视图，有裁剪框。场景：如图片裁剪框里的位置、大小调整。
//  已废弃（保留兼容）：由「UIView+CJGR + UIView+CJKeepCoveredBounds」替代：
//  内容 UIImageView（第一公民）+ cj_addPanGR/cj_addPinchGR + cj_setKeepCoveredRect:；
//  裁剪窗口展示（半透明红方块等）由宿主负责。参考演示页 TSImageEditNewModelViewController。
//  裁剪缩放调整视图：为更好使用，请继承并根据要求调用updateFrameByImage方法（附：本类里面已重写 layoutSubviews）

#import "CJAdjustGRView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJImageClipAdjustGRView : CJAdjustGRView {
    
}
@property (nonatomic, strong) UIImage *image;   // 要裁剪的图片（请在 init 后设置)

#pragma mark - Init
/*
 *  初始化
 *
 *  @param clippingViewCreateBlock  裁剪框的创建(可以为nil)
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithClippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_UNAVAILABLE;


#pragma mark - Get
/*
 *  获取要裁剪/处在裁剪区域clippingFrame中的图片像素区域：使用场景图片裁剪
 *
 *  @return 与裁剪区域clippingFrame相交/重叠的那部分显示视图frame
 */
- (CGRect)getClippingPixelRect;


#pragma mark - Update
/*
 *  根据得到的图片，在保持其比例的情况下，更新图片所占的frame（请在每次得到图片的时候调用此方法）
 *
 *  @param image 通过imageName或imageUrl等得到的图片
 */
- (void)updateFrameByImage:(UIImage *)image;

#pragma mark - Get
// 提供 ImageView 供外部设置网络图片时候使用
- (UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
