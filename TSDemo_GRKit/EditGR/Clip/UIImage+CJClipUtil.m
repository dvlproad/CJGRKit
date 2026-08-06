//
//  UIImage+CJClipUtil.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "UIImage+CJClipUtil.h"

@interface UIImage (CJClipUtilPrivate)

+ (UIImage *)cj_circularClipImage:(UIImage *)image;

@end

@implementation UIImage (CJClipUtil)

/*
 *  按像素区域裁剪图片，可按裁剪形状（矩形/圆形）裁剪
 *
 *  @param image            要裁剪的图片
 *  @param pixelRect        要裁剪的像素区域
 *  @param pathType         裁剪的形状（矩形/圆形）
 *
 *  @return 裁剪后的图片
 */
+ (UIImage *)cj_clipImage:(UIImage *)image
              inPixelRect:(CGRect)pixelRect
                 pathType:(CJRectPathType)pathType
{
    if (image == nil) {
        return nil;
    }
    
    CGRect integralRect = CGRectIntegral(pixelRect);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, integralRect);
    UIImage *clipImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (pathType == CJRectPathTypeCircle) {
        return [UIImage cj_circularClipImage:clipImage];
    }
    return clipImage;
}

@end


@implementation UIImage (CJClipUtilPrivate)

//圆形图片
+ (UIImage *)cj_circularClipImage:(UIImage *)image
{
    if (image == nil) {
        return nil;
    }
    
    CGFloat arcCenterX = image.size.width/ 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX , arcCenterY, image.size.width/ 2 , 0.0, 2*M_PI, NO);
    CGContextClip(context);
    [image drawAtPoint:CGPointZero];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
