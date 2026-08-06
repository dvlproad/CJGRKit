//
//  UIView+CJAnyGR.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/05.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：通过给任意 UIView 添加独立的拖动、捏合缩放、旋转手势，使其具备可编辑能力。
//  三个手势相互独立，可按需添加、任意组合（例如只加拖动，或拖动+缩放+旋转全加）。
//  缩放和旋转统一通过 transform 执行，拖动通过 center 执行，因此组合使用不会坐标错位。

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  类目说明：给任意 UIView 添加独立手势，实现拖动平移、捏合缩放、旋转
 */
@interface UIView (CJAnyGR)

#pragma mark - 状态读取

@property (nonatomic, assign, readonly) CGFloat cjGRScale;       /**< 当前缩放倍数（默认1） */
@property (nonatomic, assign, readonly) CGFloat cjGRRotation;    /**< 当前旋转弧度（默认0） */

#pragma mark - 缩放范围

/**
 *  最小缩放倍数（默认0.3）。可修改，用于限制缩放下限。
 *  被以下地方共用：捏合手势 cj_addPinchGR、角按钮右下缩放柄 cj_setGRScale:（CJCornerGR）。
 */
@property (nonatomic, assign) CGFloat cjGRMinScale;
/**
 *  最大缩放倍数（默认6.0）。可修改，用于限制缩放上限。
 *  被以下地方共用：捏合手势 cj_addPinchGR、角按钮右下缩放柄 cj_setGRScale:（CJCornerGR）。
 */
@property (nonatomic, assign) CGFloat cjGRMaxScale;

#pragma mark - 添加手势

/// 添加拖动平移手势
- (void)cj_addPanGR;
/// 添加捏合缩放手势
- (void)cj_addPinchGR;
/// 添加旋转手势
- (void)cj_addRotationGR;

#pragma mark - 状态写入

/// 设置缩放倍数并刷新 transform（供 CJCornerGR 等共享状态使用）
- (void)cj_setGRScale:(CGFloat)scale;
/// 设置旋转弧度并刷新 transform（供 CJCornerGR 等共享状态使用）
- (void)cj_setGRRotation:(CGFloat)rotation;

#pragma mark - 状态回调

/// 手势类型
typedef NS_ENUM(NSInteger, CJGRType) {
    CJGRTypePan,        ///< 拖动平移
    CJGRTypePinch,      ///< 捏合缩放
    CJGRTypeRotation,   ///< 旋转
};

/**
 *  手势状态变化回调（Began/Changed/Ended/Cancelled 等）。
 *  拖动、捏合、旋转任一手势状态变化时都会回调，type 标识手势来源（用于区分 Pan/Pinch/Rotation）。
 *  注意：此为公共能力，请勿在需要 KeepBounds 家族吸附的视图上自定义
 *  （吸附时机由使用方通过 cjGRStateChangeBlock2 观察手势结束并调用 cj_keepCoveredAdsorb 触发）。
 */
@property (nonatomic, copy, nullable) void(^cjGRStateChangeBlock)(CJGRType type, UIGestureRecognizerState state);

/**
 *  额外的手势状态观察回调：与 cjGRStateChangeBlock 并存、互不覆盖。
 *  用于在手势结束时触发吸附（如 UIView+CJKeepCoveredBounds 的 cj_keepCoveredAdsorb）或观察手势状态。
 */
@property (nonatomic, copy, nullable) void(^cjGRStateChangeBlock2)(CJGRType type, UIGestureRecognizerState state);

@end

NS_ASSUME_NONNULL_END
