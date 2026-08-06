//
//  CJCornerGRPanResizeCalculator.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "CJCornerGRPanResizeCalculator.h"

@implementation CJCornerGRPanResizeCalculator {
    CGPoint _startVector;       // 起始“中心→右下角”向量（屏幕坐标）
    CGFloat _startLength;       // 起始向量长度
    CGFloat _startScale;        // 拖动开始时的缩放
    CGFloat _startRotation;     // 拖动开始时的旋转
}

- (void)panBeganWithCornerVector:(CGPoint)cornerVector
                      startScale:(CGFloat)startScale
                   startRotation:(CGFloat)startRotation {
    // 考虑当前缩放+旋转后，该向量在屏幕上的实际向量
    CGAffineTransform transform = CGAffineTransformMakeRotation(startRotation);
    transform = CGAffineTransformScale(transform, startScale, startScale);
    _startVector = CGPointApplyAffineTransform(cornerVector, transform);
    _startLength = sqrt(_startVector.x * _startVector.x + _startVector.y * _startVector.y);
    _startScale = startScale;
    _startRotation = startRotation;
}

- (CJCornerGRPanResizeResult)panChangedWithTranslation:(CGPoint)translation {
    CJCornerGRPanResizeResult result = { _startScale, _startRotation };
    if (_startLength <= 0) {
        return result;
    }

    CGPoint movedVector = CGPointMake(_startVector.x + translation.x,
                                      _startVector.y + translation.y);
    CGFloat movedLength = sqrt(movedVector.x * movedVector.x + movedVector.y * movedVector.y);
    if (movedLength <= 0) {
        return result;
    }

    // 缩放 = 向量长度之比，旋转 = 向量角度之差（右下角点绕中心运动）
    result.scale = (movedLength / _startLength) * _startScale;
    result.rotation = atan2(movedVector.y, movedVector.x)
                    - atan2(_startVector.y, _startVector.x)
                    + _startRotation;
    return result;
}

@end
