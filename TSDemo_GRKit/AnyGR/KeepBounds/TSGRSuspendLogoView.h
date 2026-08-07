//
//  TSGRSuspendLogoView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  悬浮按钮：随机背景图 + 右上角 ✕ 关闭；可拖动，松手 window 级内方向吸附（KeepInBounds）。
//

#import <UIKit/UIKit.h>

@interface TSGRSuspendLogoView : UIView

/// 添加到 keyWindow 居中显示（可拖动，松手吸附回 window 边界；点击背景或右上角 ✕ 关闭）
+ (instancetype)show;

@end
