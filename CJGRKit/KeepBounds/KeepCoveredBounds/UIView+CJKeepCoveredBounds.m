//
//  UIView+CJKeepCoveredBounds.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "UIView+CJKeepCoveredBounds.h"
#import "CGRectCJAdjustHelper.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, assign) CGRect cjKeepCoveredRect;

@end

@implementation UIView (CJKeepCoveredBounds)

#pragma mark - runtime
static NSString * const cjKeepCoveredRectKey = @"cjKeepCoveredRectKey";
static NSString * const cjKeepCoveredEnabledKey = @"cjKeepCoveredEnabledKey";

//cjKeepCoveredRect
- (CGRect)cjKeepCoveredRect {
    NSValue *rectValue = objc_getAssociatedObject(self, &cjKeepCoveredRectKey);
    return rectValue ? [rectValue CGRectValue] : CGRectNull;
}

- (void)setCjKeepCoveredRect:(CGRect)cjKeepCoveredRect {
    objc_setAssociatedObject(self, &cjKeepCoveredRectKey, [NSValue valueWithCGRect:cjKeepCoveredRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjKeepCoveredEnabled
- (BOOL)cjKeepCoveredEnabled {
    NSNumber *enabledValue = objc_getAssociatedObject(self, &cjKeepCoveredEnabledKey);
    return enabledValue ? [enabledValue boolValue] : NO;
}

- (void)setCjKeepCoveredEnabled:(BOOL)cjKeepCoveredEnabled {
    objc_setAssociatedObject(self, &cjKeepCoveredEnabledKey, @(cjKeepCoveredEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - set
- (void)cj_setKeepCoveredRect:(CGRect)coveredRect {
    self.cjKeepCoveredRect = coveredRect;
    self.cjKeepCoveredEnabled = YES;
}

#pragma mark - constrain
/// 手势结束后手动触发吸附：调整内容 rect 使其覆盖住裁剪窗口（内容 rect ⊃ 窗口矩形、尺寸不小于窗口矩形）
- (void)cj_keepCoveredAdsorb {
    if (!self.cjKeepCoveredEnabled || !self.superview) {
        return;
    }
    CGRect coveredRect = self.cjKeepCoveredRect;
    if (CGRectIsNull(coveredRect) || CGRectIsEmpty(coveredRect)) {
        return;
    }
    CGSize contentSize = self.bounds.size;
    if (contentSize.width <= 0 || contentSize.height <= 0) {
        return;
    }
    
    // 当前内容渲染矩形（superview 坐标系，缩放走 transform，无旋转场景）
    //（transform 为纯缩放时 self.frame 即渲染矩形，故直接以 self.frame 为现状）
    CGRect contentRect = self.frame;

    // 吸附：调整内容 rect 使其大小不小于窗口（保持内容宽高比）、位置包含住窗口
    CGRect newRect = [CGRectCJAdjustHelper adjustCageFrame:self.frame
                                     accordingToSmallFrame:coveredRect
                                            adjustCageSize:YES
                                              adjustCageXY:YES];

    CGFloat newScale = CGRectGetWidth(newRect) / contentSize.width;
    CGPoint newCenter = CGPointMake(CGRectGetMidX(newRect), CGRectGetMidY(newRect));
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        // 保留当前旋转角，仅更新缩放倍率（等价原 GR 的 cj_setGRScale: 语义）
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, newScale, newScale);
        transform = CGAffineTransformRotate(transform, atan2(self.transform.b, self.transform.a));
        self.transform = transform;
        self.center = newCenter;
    } completion:nil];
}

@end
