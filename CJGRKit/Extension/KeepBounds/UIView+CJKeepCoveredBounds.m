//
//  UIView+CJKeepCoveredBounds.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "UIView+CJKeepCoveredBounds.h"
#import "UIView+CJGR.h"
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
    
    // 绑定一次手势状态回调：手势结束后自动吸附回合法域
    __weak typeof(self) weakSelf = self;
    self.cjGRStateChangeBlock = ^(UIGestureRecognizerState state) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (state == UIGestureRecognizerStateBegan ||
            state == UIGestureRecognizerStateChanged ||
            state == UIGestureRecognizerStateEnded ||
            state == UIGestureRecognizerStateCancelled) {
            [strongSelf __cj_keepCoveredConstrainForState:state];
        }
    };
}

#pragma mark - constrain
/// 对手势变换后的内容执行外方向约束：手势进行中自由变换不做 clamp，手势结束吸附回「内容覆盖窗口」的合法域
- (void)__cj_keepCoveredConstrainForState:(UIGestureRecognizerState)state {
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
    
    // 拖动/缩放过程中自由变换（可超出窗口）；仅手势结束后吸附回合法域
    BOOL needAdsorb = (state == UIGestureRecognizerStateEnded ||
                       state == UIGestureRecognizerStateCancelled);
    if (!needAdsorb) {
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
        [self cj_setGRScale:newScale];
        self.center = newCenter;
    } completion:nil];
}

@end
