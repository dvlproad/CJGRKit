//
//  UIView+CJGR.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/05.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "UIView+CJGR.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, assign) UIPanGestureRecognizer *cjPanGR;
@property (nonatomic, assign) UIPinchGestureRecognizer *cjPinchGR;
@property (nonatomic, assign) UIRotationGestureRecognizer *cjRotationGR;

@property (nonatomic, assign) CGFloat cjGRScaleValue;
@property (nonatomic, assign) CGFloat cjGRRotationValue;

@property (nonatomic, assign) CGFloat cjGRMinScale;
@property (nonatomic, assign) CGFloat cjGRMaxScale;

@property (nonatomic, copy) void(^cjGRStateChangeBlock)(UIGestureRecognizerState state);

@end

@implementation UIView (CJGR)

static NSString * const cjPanGRKey = @"cjPanGRKey";
static NSString * const cjPinchGRKey = @"cjPinchGRKey";
static NSString * const cjRotationGRKey = @"cjRotationGRKey";
static NSString * const cjGRScaleValueKey = @"cjGRScaleValueKey";
static NSString * const cjGRRotationValueKey = @"cjGRRotationValueKey";
static NSString * const cjGRMinScaleKey = @"cjGRMinScaleKey";
static NSString * const cjGRMaxScaleKey = @"cjGRMaxScaleKey";
static NSString * const cjGRStateChangeBlockKey = @"cjGRStateChangeBlockKey";

static const CGFloat CJGRDefaultMinScale = 0.3;   // 默认最小缩放倍数，属性 cjGRMinScale 未设置时使用
static const CGFloat CJGRDefaultMaxScale = 6.0;   // 默认最大缩放倍数，属性 cjGRMaxScale 未设置时使用

#pragma mark - runtime
//cjPanGR
- (UIPanGestureRecognizer *)cjPanGR {
    return objc_getAssociatedObject(self, &cjPanGRKey);
}

- (void)setCjPanGR:(UIPanGestureRecognizer *)cjPanGR {
    objc_setAssociatedObject(self, &cjPanGRKey, cjPanGR, OBJC_ASSOCIATION_ASSIGN);
}

//cjPinchGR
- (UIPinchGestureRecognizer *)cjPinchGR {
    return objc_getAssociatedObject(self, &cjPinchGRKey);
}

- (void)setCjPinchGR:(UIPinchGestureRecognizer *)cjPinchGR {
    objc_setAssociatedObject(self, &cjPinchGRKey, cjPinchGR, OBJC_ASSOCIATION_ASSIGN);
}

//cjRotationGR
- (UIRotationGestureRecognizer *)cjRotationGR {
    return objc_getAssociatedObject(self, &cjRotationGRKey);
}

- (void)setCjRotationGR:(UIRotationGestureRecognizer *)cjRotationGR {
    objc_setAssociatedObject(self, &cjRotationGRKey, cjRotationGR, OBJC_ASSOCIATION_ASSIGN);
}

//cjGRScaleValue
- (CGFloat)cjGRScaleValue {
    CGFloat scaleValue = [objc_getAssociatedObject(self, &cjGRScaleValueKey) floatValue];
    return scaleValue > 0 ? scaleValue : 1.0f;
}

- (void)setCjGRScaleValue:(CGFloat)cjGRScaleValue {
    objc_setAssociatedObject(self, &cjGRScaleValueKey, @(cjGRScaleValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjGRRotationValue
- (CGFloat)cjGRRotationValue {
    return [objc_getAssociatedObject(self, &cjGRRotationValueKey) floatValue];
}

- (void)setCjGRRotationValue:(CGFloat)cjGRRotationValue {
    objc_setAssociatedObject(self, &cjGRRotationValueKey, @(cjGRRotationValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjGRScale
- (CGFloat)cjGRScale {
    return self.cjGRScaleValue;
}

//cjGRRotation
- (CGFloat)cjGRRotation {
    return self.cjGRRotationValue;
}

//cjGRMinScale
- (CGFloat)cjGRMinScale {
    CGFloat minScale = [objc_getAssociatedObject(self, &cjGRMinScaleKey) floatValue];
    return minScale > 0 ? minScale : CJGRDefaultMinScale;
}

- (void)setCjGRMinScale:(CGFloat)cjGRMinScale {
    objc_setAssociatedObject(self, &cjGRMinScaleKey, @(cjGRMinScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjGRMaxScale
- (CGFloat)cjGRMaxScale {
    CGFloat maxScale = [objc_getAssociatedObject(self, &cjGRMaxScaleKey) floatValue];
    return maxScale > 0 ? maxScale : CJGRDefaultMaxScale;
}

- (void)setCjGRMaxScale:(CGFloat)cjGRMaxScale {
    objc_setAssociatedObject(self, &cjGRMaxScaleKey, @(cjGRMaxScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjGRStateChangeBlock
- (void (^)(UIGestureRecognizerState))cjGRStateChangeBlock {
    return objc_getAssociatedObject(self, &cjGRStateChangeBlockKey);
}

- (void)setCjGRStateChangeBlock:(void (^)(UIGestureRecognizerState))cjGRStateChangeBlock {
    objc_setAssociatedObject(self, &cjGRStateChangeBlockKey, cjGRStateChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/// 手势状态变化时，统一回调给外部（用于感知变换开始/进行/结束）
- (void)__cj_notifyGRStateChange:(UIGestureRecognizerState)state {
    if (self.cjGRStateChangeBlock) {
        self.cjGRStateChangeBlock(state);
    }
}

#pragma mark - add
/// 添加拖动平移手势
- (void)cj_addPanGR {
    if (self.cjPanGR) { //已添加过，不再重复添加
        return;
    }
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cj_panGRAction:)];
    panGR.minimumNumberOfTouches = 1;
    panGR.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGR];
    
    self.cjPanGR = panGR;
}

/// 添加捏合缩放手势
- (void)cj_addPinchGR {
    if (self.cjPinchGR) { //已添加过，不再重复添加
        return;
    }
    
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(cj_pinchGRAction:)];
    [self addGestureRecognizer:pinchGR];
    
    self.cjPinchGR = pinchGR;
}

/// 添加旋转手势
- (void)cj_addRotationGR {
    if (self.cjRotationGR) { //已添加过，不再重复添加
        return;
    }
    
    UIRotationGestureRecognizer *rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(cj_rotationGRAction:)];
    [self addGestureRecognizer:rotationGR];
    
    self.cjRotationGR = rotationGR;
}

#pragma mark - action
/// 拖动事件
- (void)cj_panGRAction:(UIPanGestureRecognizer *)panGR {
    switch (panGR.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGR translationInView:self.superview];
            self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
            [panGR setTranslation:CGPointZero inView:self.superview];
            break;
        }
        default:
            break;
    }
    [self __cj_notifyGRStateChange:panGR.state];
}

/// 捏合缩放事件
- (void)cj_pinchGRAction:(UIPinchGestureRecognizer *)pinchGR {
    switch (pinchGR.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.cjGRScaleValue = [self __cj_clampedScale:self.cjGRScaleValue * pinchGR.scale];
            [self cj_applyGRTransform];
            pinchGR.scale = 1.0f;
            break;
        }
        default:
            break;
    }
    [self __cj_notifyGRStateChange:pinchGR.state];
}

/// 旋转事件
- (void)cj_rotationGRAction:(UIRotationGestureRecognizer *)rotationGR {
    switch (rotationGR.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.cjGRRotationValue = self.cjGRRotationValue + rotationGR.rotation;
            [self cj_applyGRTransform];
            rotationGR.rotation = 0.0f;
            break;
        }
        default:
            break;
    }
    [self __cj_notifyGRStateChange:rotationGR.state];
}

/// 统一执行 transform（缩放+旋转），拖动通过 center 执行，互不干扰
- (void)cj_applyGRTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, self.cjGRScaleValue, self.cjGRScaleValue);
    transform = CGAffineTransformRotate(transform, self.cjGRRotationValue);
    self.transform = transform;
}

#pragma mark - set
- (void)cj_setGRScale:(CGFloat)scale {
    self.cjGRScaleValue = [self __cj_clampedScale:scale];
    [self cj_applyGRTransform];
}

- (void)cj_setGRRotation:(CGFloat)rotation {
    self.cjGRRotationValue = rotation;
    [self cj_applyGRTransform];
}

- (CGFloat)__cj_clampedScale:(CGFloat)scale {
    if (!isfinite(scale) || scale <= 0) {
        return self.cjGRScaleValue > 0 ? self.cjGRScaleValue : 1.0f;
    }
    return MIN(MAX(scale, self.cjGRMinScale), self.cjGRMaxScale);
}

@end
