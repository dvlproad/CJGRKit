//
//  TSImageEditNewModelViewController.h
//  CJViewGRDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  新模型迁移验证：图片裁剪（内容 UIImageView + GR 变换 + Clip 裁剪约束）
//  对齐旧 CJImageClipAdjustGRView 的展示：内容铺满编辑区，裁剪窗口为盖在内容上的半透明红方块
//  内容视图是第一公民，裁剪窗口不实体化（只是展示覆盖层 + 约束叠加）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSImageEditNewModelViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
