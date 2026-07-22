//
//  BLClipImageView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/9.
//

#import <CJGRKit/CJMaskImageAdjustGRView.h>
#import <UIPathCJHelper/UIBezierPathCJHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLClipImageView : CJMaskImageAdjustGRView {
    
}
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithClippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock NS_UNAVAILABLE;

/// 是否显示照片的呗遮挡区域
- (void)showOther:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
