//
//  TSKeepCoveredBoundsViewController.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：UIView+CJKeepCoveredBounds 外方向约束验证页。
//  本质模型：内容视图是第一公民，裁剪窗口不实体化，它只是内容上的一个约束（mask/clip + clamp + 吸附）。

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSKeepCoveredBoundsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
