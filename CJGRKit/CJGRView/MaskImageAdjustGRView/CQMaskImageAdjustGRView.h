//
//  CQMaskImageAdjustGRView.h
//  TSDemo_ImageFilter
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

/// 是否显示照片的呗遮挡区域
- (void)showOther:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
