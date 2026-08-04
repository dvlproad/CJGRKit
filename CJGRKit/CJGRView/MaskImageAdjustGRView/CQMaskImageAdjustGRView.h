//
//  CQMaskImageAdjustGRView.h
//  CJViewGRDemo
//
//  Created by qian on 2021/3/9.
//
//  已完成定制有遮罩层的图片裁剪调整（缩放、拖动）视图

#import <CJGRKit/CJMaskImageAdjustGRView.h>
#import <UIPathCJHelper/UIBezierPathCJHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQMaskImageAdjustGRView : CJMaskImageAdjustGRView {
    
}
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithClippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_UNAVAILABLE;

/// 静止时（非手势中）裁剪框外蒙层的透明度（默认 1.0 即完全遮住，看不到框外图片；设为 0.7 左右可看到框外图片）
@property (nonatomic, assign) CGFloat restMaskOpacity;

/// 是否显示照片的呗遮挡区域
- (void)showOther:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
