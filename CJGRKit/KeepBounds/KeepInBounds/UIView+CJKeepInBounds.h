//
//  UIView+CJKeepInBounds.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//
//  说明：本类目与 UIView+CJKeepCoveredBounds 同属 KeepBounds 家族（CJGRKit/KeepBounds 下，共享 AdjustHelper 几何核心）。
//  In/Covered 指的是约束的保证方式：本视图是小框（内框）保持在其边界内 / 本视图是大框（外框）始终保持覆盖住窗口，不是 keep out of bounds：
//  ① CJKeepInBounds（内）：本视图是小框（内框），边界是父视图/keyWindow（大框），保证 本视图 ⊂ 边界
//  ② CJKeepCoveredBounds（外）：本视图是大框（外框），裁剪窗口是内部的小框，保证 本视图 ⊃ 窗口
//  是否需要调整尺寸是正交的独立维度：内方向尺寸固定不变；外方向可配置 adjustCageSize 放大以包含住小框。
//
//  手势来源       约束时机
//  CJKeepInBounds（内）      UIView+CJAnyGR    手动调用（你拖完自己想黏合时调 cjKeepBounds，它不自动观察手势）
//  CJKeepCoveredBounds（外） UIView+CJAnyGR    手动调用（手势 Ended/Cancelled 时由外部调用 cj_keepCoveredAdsorb 吸附，本类不感知手势）

#import <UIKit/UIKit.h>

//①不仅能够满足view在superView上的黏合，②还能满足当该view是window时，在keyWindow上的黏合
@interface UIView (CJKeepInBounds)

/*
 *  黏合区域(①当视图超出边界的时候，XY是否黏合最近边界;②当视图没超出边界的时候，X也会黏合最近边界)
 */
- (void)cjKeepBounds;

/*
 *  黏合区域（吸附时候：如果是view最大到其父视图的范围，如果是window最大到keyWindow）
 *
 *  @param boundEdgeInsets                  黏合区域（黏合时候与边界的边距，上下边界可以完全黏合的时候是UIEdgeInsetsZero）
 *  @param isKeepBoundsXYWhenBeyondBound    当视图超出边界的时候，XY是否黏合最近边界
 *  @param isKeepBoundsXWhenContaintInBound 当视图没超出边界的时候，X是否黏合最近边界
 *  @param isKeepBoundsYWhenContaintInBound 当视图没超出边界的时候，Y是否黏合最近边界
 */
- (void)cjKeepBoundsWithBoundEdgeInsets:(UIEdgeInsets)boundEdgeInsets
          isKeepBoundsXYWhenBeyondBound:(BOOL)isKeepBoundsXYWhenBeyondBound
       isKeepBoundsXWhenContaintInBound:(BOOL)isKeepBoundsXWhenContaintInBound
       isKeepBoundsYWhenContaintInBound:(BOOL)isKeepBoundsYWhenContaintInBound;

@end
