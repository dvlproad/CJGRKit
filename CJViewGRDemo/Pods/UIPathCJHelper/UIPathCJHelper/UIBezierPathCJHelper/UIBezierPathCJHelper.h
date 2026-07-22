//
//  UIBezierPathCJHelper.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2014/5/8.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//
//  获取各种条件下的路径

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 矩形框内要绘制的路径
typedef NS_ENUM(NSUInteger, CJRectPathType) {
    CJRectPathTypeRectangle = 0,    /**< 方形 */
    CJRectPathTypeCircle,           /**< 圆形 */
};


@interface UIBezierPathCJHelper : NSObject

/*
 *  获取由【指定的点】构成的规则或不规则的路径
 *
 *  @param pointStrings     要构成路径的那些点
 *  @param hisFrame         那些点坐标是相对那个frame的
 *
 *  @return 由【指定的点】构成的规则或不规则的路径
 */
+ (UIBezierPath *)bezierPathForPointStrings:(NSArray<NSString *> *)pointStrings inHisFrame:(CGRect)hisFrame;

/*
 *  获取空心区域/镂空区域的path路径
 *
 *  @param rectFrame            空心区域的矩形大小
 *  @param pathType             空心区域的形状
 *
 *  @return 空心区域/镂空区域的path路径
 */
+ (UIBezierPath *)bezierPathForRectFrame:(CGRect)rectFrame pathType:(CJRectPathType)pathType;

@end

NS_ASSUME_NONNULL_END
