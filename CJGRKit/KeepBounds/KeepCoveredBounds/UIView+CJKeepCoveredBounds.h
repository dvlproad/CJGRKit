//
//  UIView+CJKeepCoveredBounds.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：本类目与 UIView+CJKeepInBounds 同属 KeepBounds 家族（CJGRKit/KeepBounds 下，共享 AdjustHelper 几何核心）。
//  给可手势变换的视图（配合 UIView+CJAnyGR 使用）叠加外方向约束（内容始终覆盖/包含住裁剪窗口）。
//  名字含义：keep [窗口的] bounds covered——本视图（大框）始终保持覆盖住窗口（小框），保证 本视图 ⊃ 窗口。
//  本质模型：内容视图是第一公民，裁剪窗口不实体化，它只是内容上的一个"约束"。
//  约束规则：内容始终覆盖裁剪窗口（位置不能拖出、缩放不能小于覆盖所需），手势结束后自动吸附回合法域。
//
//  手势来源       约束时机
//  CJKeepInBounds（内）      UIView+CJAnyGR    手动调用（你拖完自己想黏合时调 cjKeepBounds，它不自动观察手势）
//  CJKeepCoveredBounds（外） UIView+CJAnyGR    手动调用（手势 Ended/Cancelled 时由外部调用 cj_keepCoveredAdsorb 吸附，本类不感知手势）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  类目说明：给任意可手势变换的视图叠加外方向约束，使其始终覆盖/包含住裁剪窗口（受限移动/缩放）。
 *  配合使用：先给内容视图添加手势（cj_addPanGR/cj_addPinchGR 等），再设置裁剪窗口矩形即可。
 *  本类不感知手势、不自动吸附；吸附时机由使用方在手势 Ended/Cancelled 时调用 cj_keepCoveredAdsorb 触发
 *  （例如在手势状态回调里：手势结束后调用吸附）。
 *  注意：本组件只做"行为约束"，不自动改变视图层级。显示裁剪（把内容裁到裁剪窗口）由宿主负责，
 *  常见做法是父视图 clipsToBounds，或对内容设置 layer.mask。
 */
@interface UIView (CJKeepCoveredBounds)

#pragma mark - 外方向 keep-bounds 约束

/**
 *  设置「需保持被覆盖」的窗口矩形（外部坐标系，一般为 superview 坐标系）并启用外方向约束。
 *  约束规则：手势进行中内容可自由拖动/缩放（可超出窗口），手势结束后由外部调用
 *  cj_keepCoveredAdsorb 吸附回合法域（内容 rect 始终包含住该窗口矩形，且尺寸不小于该窗口矩形）。
 */
- (void)cj_setKeepCoveredRect:(CGRect)coveredRect;

/// 外方向约束开关（设置窗口矩形后默认开启）
@property (nonatomic, assign) BOOL cjKeepCoveredEnabled;

/// 手势结束后手动触发吸附：调整内容 rect 使其覆盖住裁剪窗口（内容 rect ⊃ 窗口矩形、尺寸不小于窗口矩形）
- (void)cj_keepCoveredAdsorb;

@end

NS_ASSUME_NONNULL_END
