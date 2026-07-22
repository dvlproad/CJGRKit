//
//  CJMaskImageAdjustGRView.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/9.
//

#import "CJMaskImageAdjustGRView.h"

@implementation CJMaskImageAdjustGRView

/*
 *  添加蒙层
 *
 *  @param rectPathType     裁剪的形状
 *  @param opacity          透明度
 */
- (void)addMaskLayerWithRectPathType:(CJRectPathType)rectPathType opacity:(CGFloat)opacity {
    _clearRectangleType = rectPathType;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.fillColor = [[UIColor blackColor] CGColor];
    maskLayer.opacity = opacity;
    [self.layer addSublayer:maskLayer];
    _maskLayer = maskLayer;
}

#pragma mark - DrawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *path= [UIBezierPath bezierPathWithRect:rect];
    // 获取空心区域/镂空区域的path路径
    UIBezierPath *clearPath = [UIBezierPathCJHelper bezierPathForRectFrame:self.clippingFrame
                                                                  pathType:self.clearRectangleType];
    [path appendPath:clearPath];
    [path setUsesEvenOddFillRule:YES];
    
    self.maskLayer.path = path.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
