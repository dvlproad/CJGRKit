//
//  CJImageAdjustGRView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//
//  图片普通调整（缩放、拖动）视图，没有裁剪框。
//  场景：如图片拼接里的位置、大小调整。
//  新模型组件基类：内容 UIImageView 是第一公民，内部已内置
//  拖动/捏合手势（UIView+CJAnyGR）、裁剪窗口约束（UIView+CJKeepCoveredBounds）。
//  注意：裁剪窗口(cropRect)仅作为内部拖动约束与裁剪计算用，本视图不绘制裁剪框。
//  CJMaskImageAdjustGRView 继承本类追加镂空蒙层。
//  替代旧 CJImageNormalAdjustGRView/CJImageClipAdjustGRView。
//  注意：组件按固定尺寸编辑区设计（Auto Layout 布局一次后裁剪窗口/内容即固定），
//  若运行期再改变编辑区尺寸，需重建组件或手动重置。

#import <UIKit/UIKit.h>
#import <CJGRKit/UIView+CJAnyGR.h>                  // CJGRType

NS_ASSUME_NONNULL_BEGIN

@interface CJImageAdjustGRView : UIView

/// 内容：图片本身（第一公民，已开启 userInteractionEnabled，内置手势/约束）
@property (nonatomic, strong, readonly) UIImageView *contentView;

/// 快捷设置图片（setter 内更新布局，覆盖裁剪窗口并居中）。请用此属性设图，勿直接改 contentView.image
@property (nonatomic, strong, nullable) UIImage *image;

/// 裁剪窗口（组件 bounds 坐标系）；未手动设置时内部按 cropRatio 计算
@property (nonatomic, assign) CGRect cropRect;

/// 裁剪窗口宽高比，默认 1:1，可配置；cropRectCoversBounds=NO 时 layoutSubviews 据此自动生成 cropRect
@property (nonatomic, assign) CGFloat cropRatio;

/// 裁剪窗口是否盖满整个编辑区（bounds），默认 YES；
/// YES = cropRect 即整个编辑区（内容约束填满编辑区，图片拼接主场景）；
/// NO = 按 cropRatio 生成居中窗口（裁剪框场景，CJMaskImageAdjustGRView 已默认 NO）
@property (nonatomic, assign) BOOL cropRectCoversBounds;

/// 裁剪窗口约束开关（默认 YES=内容覆盖裁剪窗口、手势结束自动吸附；NO=无约束可自由拖动）
@property (nonatomic, assign) BOOL keepCoveredEnabled;

/// 内置捏合缩放上限（对齐 cjGRMaxScale，默认 6.0）
@property (nonatomic, assign) CGFloat maxScale;

/// 手势状态回调（Began/Changed/Ended/Cancelled，type 区分 Pan/Pinch）
@property (nonatomic, copy, nullable) void(^grStateChangeBlock)(CJGRType type, UIGestureRecognizerState state);

/// 创建编辑容器（背景色即编辑区底色，默认裁剪超出部分）
- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor;

/// 保持图片比例、覆盖裁剪窗口并居中（重置缩放），换图/布局变化后调用
- (void)updateFrameByImage:(UIImage *)image;

/// 裁剪窗口对应的图片像素区域（供真正裁剪；内置 pan/pinch 缩放有效，若额外加旋转手势需宿主自行换算）
- (CGRect)getClippingPixelRect;

@end

NS_ASSUME_NONNULL_END
