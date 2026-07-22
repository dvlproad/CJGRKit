//
//  UIBezierPathCJHelper.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2014/5/8.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "UIBezierPathCJHelper.h"

@implementation UIBezierPathCJHelper

/*
 *  获取由【指定的点】构成的规则或不规则的路径
 *
 *  @param pointStrings     要构成路径的那些点
 *  @param hisFrame         那些点坐标是相对那个frame的
 *
 *  @return 由【指定的点】构成的规则或不规则的路径
 */
+ (UIBezierPath *)bezierPathForPointStrings:(NSArray<NSString *> *)pointStrings inHisFrame:(CGRect)hisFrame {
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSInteger pointCount = pointStrings.count;
    if (pointCount > 2) { // 当点的数量大于2个的时候
        for(int i = 0; i < pointCount; i++) {
            NSString *templatePointString = [pointStrings objectAtIndex:i];
            CGPoint templatePoint = CGPointFromString(templatePointString);

            CGFloat realPointX = templatePoint.x;
            CGFloat realPointY = templatePoint.y;
            //NSLog(@"===2222======realPointX = %.8f, realPointY = %.8f", realPointX, realPointY);
            
            realPointX = realPointX - hisFrame.origin.x;
            realPointY = realPointY - hisFrame.origin.y;
            CGPoint realPoint = CGPointMake(realPointX, realPointY);
            //NSLog(@"===3333======realPointX = %.8f, realPointY = %.8f", realPoint.x, realPoint.y);
            if (i == 0) {
                [path moveToPoint:realPoint];
            } else {
                [path addLineToPoint:realPoint];
            }
        }
        
    } else {
        //当点的左边不能形成一个面的时候，视为错误，路径使用包含这些点的frame
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(hisFrame.size.width, 0)];
        [path addLineToPoint:CGPointMake(hisFrame.size.width, hisFrame.size.height)];
        [path addLineToPoint:CGPointMake(0, hisFrame.size.height)];
    }
    
    [path closePath];
    
    return path;
}



/*
 *  获取空心区域/镂空区域的path路径
 *
 *  @param rectFrame            空心区域的矩形大小
 *  @param pathType             空心区域的形状
 *
 *  @return 空心区域/镂空区域的path路径
 */
+ (UIBezierPath *)bezierPathForRectFrame:(CGRect)rectFrame pathType:(CJRectPathType)pathType
{
    UIBezierPath *clearPath = nil;  // 空心的透明的path
    if(pathType == CJRectPathTypeCircle) { //绘制圆形裁剪区域
        CGFloat circularCenterX = rectFrame.origin.x + rectFrame.size.width/2;
        CGFloat circularCenterY = rectFrame.origin.y + rectFrame.size.height/2;
        CGPoint circularCenter = CGPointMake(circularCenterX, circularCenterY);
        CGFloat circularRadius = rectFrame.size.width/2;
        clearPath = [UIBezierPath bezierPathWithArcCenter:circularCenter radius:circularRadius startAngle:0 endAngle:2*M_PI clockwise:NO];
    } else {
        clearPath = [UIBezierPath bezierPathWithRect:rectFrame];
    }
    return clearPath;
}

@end
