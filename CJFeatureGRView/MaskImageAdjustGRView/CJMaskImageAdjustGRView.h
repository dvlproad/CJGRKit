//
//  CJMaskImageAdjustGRView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//
//  图片裁剪调整（缩放、拖动）视图，有裁剪框 + 蒙层。
//  场景：如图片裁剪框里的位置、大小调整。
//  继承 CJImageAdjustGRView 图片调整基类（内容第一公民 + 内置手势/裁剪窗口约束），
//  追加镂空蒙层（矩形/圆形，even-odd 镂空 + 窗口白边）。
//  替代旧 CJGRView/MaskImageAdjustGRView 与 CJGRMaskOverlayView。
//  注意：组件按固定尺寸编辑区设计（Auto Layout 布局一次后裁剪窗口/内容即固定），
//  若运行期再改变编辑区尺寸，需重建组件或手动重置。

#import <UIKit/UIKit.h>
#import <CJFeatureGRView/CJImageAdjustGRView.h>
#import <UIPathCJHelper/UIBezierPathCJHelper.h>  // CJRectPathType

NS_ASSUME_NONNULL_BEGIN

@interface CJMaskImageAdjustGRView : CJImageAdjustGRView

/// 镂空形状：矩形/圆形（默认矩形）
@property (nonatomic, assign) CJRectPathType shapeType;

/// 静止时框外蒙层透明度（默认 1.0 即框外隐藏）
@property (nonatomic, assign) CGFloat restMaskOpacity;

/// 创建编辑容器（背景色即编辑区底色，默认裁剪超出部分）
- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor;

/// 是否显示照片被遮挡区域（内置手势联动：拖动进行中显示，结束恢复）
- (void)showOther:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
