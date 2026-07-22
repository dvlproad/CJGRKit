//
//  CJMaskImageAdjustGRView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/9.
//

#import "CJImageClipAdjustGRView.h"
#import <UIPathCJHelper/UIBezierPathCJHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJMaskImageAdjustGRView : CJImageClipAdjustGRView {
    
}
@property (nonatomic, strong, readonly) CAShapeLayer *maskLayer;
@property (nonatomic, assign, readonly) CJRectPathType clearRectangleType;  //裁剪的形状

/*
 *  添加蒙层
 *
 *  @param rectPathType     裁剪的形状
 *  @param opacity          透明度
 */
- (void)addMaskLayerWithRectPathType:(CJRectPathType)rectPathType opacity:(CGFloat)opacity;

@end

NS_ASSUME_NONNULL_END
