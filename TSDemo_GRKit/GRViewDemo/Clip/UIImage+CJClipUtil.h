//
//  UIImage+CJClipUtil.h
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import <UIKit/UIKit.h>
#import <UIPathCJHelper/UIBezierPathCJHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CJClipUtil)

/*
 *  按像素区域裁剪图片，可按裁剪形状（矩形/圆形）裁剪
 *
 *  @param image            要裁剪的图片
 *  @param pixelRect        要裁剪的像素区域
 *  @param pathType         裁剪的形状（矩形/圆形）
 *
 *  @return 裁剪后的图片
 */
+ (nullable UIImage *)cj_clipImage:(UIImage *)image
                       inPixelRect:(CGRect)pixelRect
                          pathType:(CJRectPathType)pathType;

@end

NS_ASSUME_NONNULL_END
