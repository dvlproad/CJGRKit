//
//  CJMaskImageAdjustGRView.h
//  CJViewGRDemo
//
//  Created by qian on 2021/3/9.
//
//  用于定制有遮罩层的图片裁剪调整（缩放、拖动）视图

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

/*
 *  更新蒙层的裁剪形状（矩形/圆形），复用已有蒙层layer，用于切换预览形状
 *
 *  @param rectPathType     裁剪的形状
 */
- (void)updateMaskWithRectPathType:(CJRectPathType)rectPathType;

@end

NS_ASSUME_NONNULL_END
