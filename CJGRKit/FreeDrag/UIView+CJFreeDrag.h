//
//  UIView+CJFreeDrag.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  类目说明：通过给View添加UIPanGestureRecognizer手势，使其可以移动到拖动的位置
 *
 *  ⚠️ 已废弃（DEPRECATED）：能力已由 UIView (CJGR) 完整覆盖且实现更优（相对位移拖动、无跳变）。
 *  请改用：
 *      [view cj_addPanGR];   // 替代 cjDragEnable = YES（添加任意方向拖动）
 *      view.cjGRStateChangeBlock = ^(CJGRType type, UIGestureRecognizerState state) {
 *          // state 区分 UIGestureRecognizerStateBegan/Changed/Ended，替代 cjDragBeginBlock/cjDragDuringBlock/cjDragEndBlock
 *      };
 *  本文件将于后续版本移除，存量使用方请尽快迁移。
 */
__attribute__((deprecated("UIView+CJFreeDrag 已废弃，请改用 UIView (CJGR) 的 cj_addPanGR 与 cjGRStateChangeBlock")))
@interface UIView (CJFreeDrag)

@property (nonatomic, assign) BOOL cjDragEnable;   /**< 是否允许拖曳(默认YES) */
@property (nonatomic, copy) void(^cjDragBeginBlock)(UIView *view);    /**< 开始拖曳的回调 */
@property (nonatomic, copy) void(^cjDragDuringBlock)(UIView *view);   /**< 拖曳中的回调 */
@property (nonatomic, copy) void(^cjDragEndBlock)(UIView *view);      /**< 结束拖曳的回调 */


@end

NS_ASSUME_NONNULL_END
