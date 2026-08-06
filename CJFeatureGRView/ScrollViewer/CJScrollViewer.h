//
//  CJScrollViewer.h
//  CJFeatureGRView
//
//  Created by dvlproad on 2026/08/07.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJScrollViewer : UIScrollView

@property (nonatomic, strong, readonly) UIView *contentView;  // 缩放目标视图（viewForZoomingInScrollView 返回它）

@property (nonatomic, assign) CGFloat maxScale;               // 双击放大上限，默认 3.0

@property (nonatomic, copy, nullable) void(^singleTapBlock)(void);       // 单击回调
@property (nonatomic, copy, nullable) void(^longPressBlock)(void);       // 长按回调（Began 时触发）
@property (nonatomic, copy, nullable) void(^dragDownCloseBlock)(void);   // 下拉关闭触发回调（放大态不触发）

@end

NS_ASSUME_NONNULL_END
