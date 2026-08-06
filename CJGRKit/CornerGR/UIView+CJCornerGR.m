//
//  UIView+CJCornerGR.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/05.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "UIView+CJCornerGR.h"
#import "UIView+CJAnyGR.h"
#import "CJCornerGRPanResizeCalculator.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static const CGFloat CJCornerButtonLength = 30;

@class CJCornerGRTransformObserver;

static NSString * const cjCornerDeleteButtonKey = @"cjCornerDeleteButtonKey";
static NSString * const cjCornerUpdateButtonKey = @"cjCornerUpdateButtonKey";
static NSString * const cjCornerMinimizeHandleKey = @"cjCornerMinimizeHandleKey";
static NSString * const cjCornerDeleteBlockKey = @"cjCornerDeleteBlockKey";
static NSString * const cjCornerUpdateBlockKey = @"cjCornerUpdateBlockKey";
static NSString * const cjCornerPanResizeCalculatorKey = @"cjCornerPanResizeCalculatorKey";
static NSString * const cjCornerTransformObserverKey = @"cjCornerTransformObserverKey";

@interface UIView ()

@property (nonatomic, assign) UIView *cjCornerDeleteButton;
@property (nonatomic, assign) UIView *cjCornerUpdateButton;
@property (nonatomic, assign) UIView *cjCornerMinimizeHandle;

@property (nonatomic, copy) void(^cjCornerDeleteBlock)(UIView *view);
@property (nonatomic, copy) void(^cjCornerUpdateBlock)(UIView *view);

@property (nonatomic, strong) CJCornerGRPanResizeCalculator *cjCornerPanResizeCalculator;
@property (nonatomic, strong) CJCornerGRTransformObserver *cjCornerTransformObserver;

- (NSArray<UIView *> *)__cj_activeCornerViews;

@end

// 独立 KVO observer，避免 category 污染 UIView 的 observeValueForKeyPath:。
// 生命周期跟随视图（作为 associated object 保存）。dealloc 时若被观察视图仍存活则解绑；
// 若视图已开始释放（weak 引用已置空），则由 KVO 运行时的自动清理兜底。
@interface CJCornerGRTransformObserver : NSObject

@property (nonatomic, weak) UIView *observedView;
@property (nonatomic, copy) void(^transformChangeBlock)(UIView *view);

@end

@implementation CJCornerGRTransformObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"transform"] && context == &cjCornerTransformObserverKey) {
        if (self.transformChangeBlock) {
            self.transformChangeBlock(object);
        }
    }
}

- (void)dealloc {
    if (self.observedView) {
        @try {
            [self.observedView removeObserver:self forKeyPath:@"transform" context:(void *)&cjCornerTransformObserverKey];
        } @catch (NSException *exception) {
            // 已被 KVO 运行时清理或重复移除，忽略
        }
    }
}

@end

@implementation UIView (CJCornerGR)

#pragma mark - runtime
//cjCornerDeleteButton
- (UIView *)cjCornerDeleteButton {
    return objc_getAssociatedObject(self, &cjCornerDeleteButtonKey);
}
- (void)setCjCornerDeleteButton:(UIView *)cjCornerDeleteButton {
    objc_setAssociatedObject(self, &cjCornerDeleteButtonKey, cjCornerDeleteButton, OBJC_ASSOCIATION_ASSIGN);
}

//cjCornerUpdateButton
- (UIView *)cjCornerUpdateButton {
    return objc_getAssociatedObject(self, &cjCornerUpdateButtonKey);
}
- (void)setCjCornerUpdateButton:(UIView *)cjCornerUpdateButton {
    objc_setAssociatedObject(self, &cjCornerUpdateButtonKey, cjCornerUpdateButton, OBJC_ASSOCIATION_ASSIGN);
}

//cjCornerMinimizeHandle
- (UIView *)cjCornerMinimizeHandle {
    return objc_getAssociatedObject(self, &cjCornerMinimizeHandleKey);
}
- (void)setCjCornerMinimizeHandle:(UIView *)cjCornerMinimizeHandle {
    objc_setAssociatedObject(self, &cjCornerMinimizeHandleKey, cjCornerMinimizeHandle, OBJC_ASSOCIATION_ASSIGN);
}

//cjCornerDeleteBlock
- (void (^)(UIView *))cjCornerDeleteBlock {
    return objc_getAssociatedObject(self, &cjCornerDeleteBlockKey);
}
- (void)setCjCornerDeleteBlock:(void (^)(UIView *))cjCornerDeleteBlock {
    objc_setAssociatedObject(self, &cjCornerDeleteBlockKey, cjCornerDeleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjCornerUpdateBlock
- (void (^)(UIView *))cjCornerUpdateBlock {
    return objc_getAssociatedObject(self, &cjCornerUpdateBlockKey);
}
- (void)setCjCornerUpdateBlock:(void (^)(UIView *))cjCornerUpdateBlock {
    objc_setAssociatedObject(self, &cjCornerUpdateBlockKey, cjCornerUpdateBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjCornerPanResizeCalculator
- (CJCornerGRPanResizeCalculator *)cjCornerPanResizeCalculator {
    CJCornerGRPanResizeCalculator *calculator = objc_getAssociatedObject(self, &cjCornerPanResizeCalculatorKey);
    if (!calculator) {
        calculator = [[CJCornerGRPanResizeCalculator alloc] init];
        objc_setAssociatedObject(self, &cjCornerPanResizeCalculatorKey, calculator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return calculator;
}
- (void)setCjCornerPanResizeCalculator:(CJCornerGRPanResizeCalculator *)cjCornerPanResizeCalculator {
    objc_setAssociatedObject(self, &cjCornerPanResizeCalculatorKey, cjCornerPanResizeCalculator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjCornerTransformObserver
- (CJCornerGRTransformObserver *)cjCornerTransformObserver {
    return objc_getAssociatedObject(self, &cjCornerTransformObserverKey);
}

- (void)setCjCornerTransformObserver:(CJCornerGRTransformObserver *)cjCornerTransformObserver {
    objc_setAssociatedObject(self, &cjCornerTransformObserverKey, cjCornerTransformObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - border
- (void)cj_setCornerBorderWithColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    [self __cj_startCornerTransformObservationIfNeeded];
}

#pragma mark - delete
- (void)cj_addCornerDeleteButtonWithBlock:(void (^)(UIView *))onDelete {
    self.cjCornerDeleteBlock = onDelete;
    if (self.cjCornerDeleteButton) {
        return;
    }
    
    UIButton *button = [self __createCornerButtonWithSymbol:@"xmark.circle.fill"
                                                   tintColor:[UIColor systemRedColor]
                                                     action:@selector(__cornerDeleteAction:)];
    button.frame = CGRectMake(-CJCornerButtonLength/2, -CJCornerButtonLength/2, CJCornerButtonLength, CJCornerButtonLength);
    [self addSubview:button];
    
    self.cjCornerDeleteButton = button;
    [self __cj_startCornerTransformObservationIfNeeded];
}

- (void)__cornerDeleteAction:(UIButton *)button {
    if (self.cjCornerDeleteBlock) {
        self.cjCornerDeleteBlock(self);
    }
}

#pragma mark - update
- (void)cj_addCornerUpdateButtonWithBlock:(void (^)(UIView *))onUpdate {
    self.cjCornerUpdateBlock = onUpdate;
    if (self.cjCornerUpdateButton) {
        return;
    }
    
    UIButton *button = [self __createCornerButtonWithSymbol:@"arrow.clockwise.circle.fill"
                                                   tintColor:[UIColor systemBlueColor]
                                                     action:@selector(__cornerUpdateAction:)];
    button.frame = CGRectMake(CGRectGetMaxX(self.bounds) - CJCornerButtonLength/2,
                              -CJCornerButtonLength/2,
                              CJCornerButtonLength, CJCornerButtonLength);
    [self addSubview:button];
    
    self.cjCornerUpdateButton = button;
    [self __cj_startCornerTransformObservationIfNeeded];
}

- (void)__cornerUpdateAction:(UIButton *)button {
    if (self.cjCornerUpdateBlock) {
        self.cjCornerUpdateBlock(self);
    }
}

#pragma mark - minimize handle
- (void)cj_addCornerMinimizeHandle {
    if (self.cjCornerMinimizeHandle) {
        return;
    }
    
    UIImageView *handleView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.left.and.arrow.down.right"]];
    handleView.tintColor = [UIColor systemOrangeColor];
    handleView.contentMode = UIViewContentModeCenter;
    //handleView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // 临时可视化背景色，用于查看可操作区域
    handleView.frame = CGRectMake(CGRectGetMaxX(self.bounds) - CJCornerButtonLength/2,
                                  CGRectGetMaxY(self.bounds) - CJCornerButtonLength/2,
                                  CJCornerButtonLength, CJCornerButtonLength);
    handleView.userInteractionEnabled = YES;
    [self addSubview:handleView];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(__cornerMinimizeAction:)];
    [handleView addGestureRecognizer:panGR];
    
    self.cjCornerMinimizeHandle = handleView;
    [self __cj_startCornerTransformObservationIfNeeded];
}

- (void)__cornerMinimizeAction:(UIPanGestureRecognizer *)panGR {
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            // 记录拖动开始时的缩放、旋转，以及“中心->右下角”向量
            CGPoint cornerVector = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            [self.cjCornerPanResizeCalculator panBeganWithCornerVector:cornerVector
                                                            startScale:self.cjGRScale
                                                         startRotation:self.cjGRRotation];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGR translationInView:self.superview];
            CJCornerGRPanResizeResult result = [self.cjCornerPanResizeCalculator panChangedWithTranslation:translation];
            
            [self cj_setGRScale:result.scale];
            [self cj_setGRRotation:result.rotation];
            break;
        }
        default:
            break;
    }
}

#pragma mark - transform compensation
// 角按钮是视图的子视图，会随视图 transform 一起缩放旋转。
// 这里监听视图 transform 变化，只对缩放做反向补偿（对应 SwiftUI 的 scaleCompensation），
// 使按钮在屏幕上保持恒定大小，但方向跟随视图一起旋转。
- (void)__cj_startCornerTransformObservationIfNeeded {
    [self __cj_swizzleHitTestIfNeeded];
    if (self.cjCornerTransformObserver) {
        [self __cj_updateCornerButtonsCompensation];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    CJCornerGRTransformObserver *observer = [[CJCornerGRTransformObserver alloc] init];
    observer.observedView = self;
    observer.transformChangeBlock = ^(UIView *view) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf __cj_updateCornerButtonsCompensation];
        }
    };
    [self addObserver:observer
           forKeyPath:@"transform"
              options:NSKeyValueObservingOptionNew
              context:(void *)&cjCornerTransformObserverKey];
    
    self.cjCornerTransformObserver = observer;
    [self __cj_updateCornerButtonsCompensation];
}

- (void)__cj_updateCornerButtonsCompensation {
    // 角按钮是视图的子视图，会随视图 transform 一起缩放旋转。
    // 这里只抵消缩放（对应 SwiftUI 的 scaleCompensation = 1/displayScale），
    // 让按钮在屏幕上保持恒定大小，但仍随视图一起旋转。
    CGFloat scale = self.cjGRScale;
    if (!(scale > 0) || !isfinite(scale)) {
        scale = 1.0f;
    }
    CGAffineTransform scaleCompensation = CGAffineTransformMakeScale(1.0f/scale, 1.0f/scale);
    for (UIView *cornerView in [self __cj_activeCornerViews]) {
        if (cornerView) {
            cornerView.transform = scaleCompensation;
        }
    }
}

#pragma mark - hitTest 补充
// 角按钮的中心位于视图角上，frame 有一半伸出父视图 bounds 之外。
// UIKit 默认 hitTest: 在触摸点位于 bounds 之外时会直接返回 nil，不会检查子视图，
// 导致按钮伸出去的部分（如右下操作柄的下半、右半）画出来却点不到。
// 这里 swizzle hitTest:，先走系统默认命中，再对角按钮伸出 bounds 的部分做补充命中。
static IMP CJCornerGROriginalHitTestIMP = NULL;

static UIView *CJCornerGRHitTest(id self, SEL _cmd, CGPoint point, UIEvent *event) {
    UIView *result = ((UIView *(*)(id, SEL, CGPoint, UIEvent *))CJCornerGROriginalHitTestIMP)(self, _cmd, point, event);
    if (result) {
        return result;
    }
    if (objc_getAssociatedObject(self, &cjCornerTransformObserverKey) == nil) {
        return nil;
    }
    for (UIView *cornerView in [(UIView *)self __cj_activeCornerViews]) {
        if (cornerView.hidden || cornerView.alpha <= 0.01 || cornerView.userInteractionEnabled == NO) {
            continue;
        }
        CGPoint cornerPoint = [(UIView *)self convertPoint:point toView:cornerView];
        if ([cornerView pointInside:cornerPoint withEvent:event]) {
            return cornerView;
        }
    }
    return nil;
}

- (void)__cj_swizzleHitTestIfNeeded {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method = class_getInstanceMethod([UIView class], @selector(hitTest:withEvent:));
        CJCornerGROriginalHitTestIMP = method_getImplementation(method);
        method_setImplementation(method, (IMP)CJCornerGRHitTest);
    });
}

#pragma mark - helper
- (NSArray<UIView *> *)__cj_activeCornerViews {
    NSMutableArray<UIView *> *views = [NSMutableArray array];
    if (self.cjCornerDeleteButton) {
        [views addObject:self.cjCornerDeleteButton];
    }
    if (self.cjCornerUpdateButton) {
        [views addObject:self.cjCornerUpdateButton];
    }
    if (self.cjCornerMinimizeHandle) {
        [views addObject:self.cjCornerMinimizeHandle];
    }
    return [views copy];
}

- (UIButton *)__createCornerButtonWithSymbol:(NSString *)symbolName
                                   tintColor:(UIColor *)tintColor
                                      action:(SEL)action {
    UIImage *image = [UIImage systemImageNamed:symbolName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = tintColor;
    //button.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // 临时可视化背景色，用于查看可操作区域
    button.layer.cornerRadius = CJCornerButtonLength/2;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 1);
    button.layer.shadowOpacity = 0.4;
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
