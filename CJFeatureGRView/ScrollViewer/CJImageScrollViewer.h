//
//  CJImageScrollViewer.h
//  CJFeatureGRView
//
//  Created by dvlproad on 2026/08/07.
//

#import "CJScrollViewer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJImageScrollViewer : CJScrollViewer

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, nullable) UIImage *image;   // 设图 → 初始布局（整图 fit 居中）

@end

NS_ASSUME_NONNULL_END
