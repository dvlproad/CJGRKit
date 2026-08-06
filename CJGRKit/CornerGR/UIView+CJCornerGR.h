//
//  UIView+CJCornerGR.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/05.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：给任意 UIView 添加角按钮编辑层（边框、删除、更新、右下缩放旋转柄）。
//  各角按钮相互独立，可按需添加：只加边框、边框+删除、或四件套全加。

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  类目说明：给任意 UIView 添加角按钮编辑层，各能力相互独立可组合
 */
@interface UIView (CJCornerGR)

#pragma mark - 设置

/// 设置边框（自定义颜色，线宽随视图缩放一起变化）
- (void)cj_setCornerBorderWithColor:(UIColor *)color;

#pragma mark - 添加角按钮

/// 添加左上角删除按钮（点击触发 onDelete）
- (void)cj_addCornerDeleteButtonWithBlock:(void(^)(UIView *view))onDelete;

/// 添加右上角更新按钮（点击触发 onUpdate）
- (void)cj_addCornerUpdateButtonWithBlock:(void(^)(UIView *view))onUpdate;

/// 添加右下角缩放/旋转操作柄（拖动该角点，绕视图中心缩放和旋转视图）
- (void)cj_addCornerMinimizeHandle;

@end

NS_ASSUME_NONNULL_END
