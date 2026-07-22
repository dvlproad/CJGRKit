//
//  CQMaskImageAdjustGRView.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/9.
//

#import "CQMaskImageAdjustGRView.h"

@implementation CQMaskImageAdjustGRView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithClippingViewCreateBlock:^UIView * _Nonnull{
        UIView *clippingRegionView = [[UIView alloc] init];
        //clippingRegionView.layer.borderWidth = 1;
        //clippingRegionView.layer.borderColor = [UIColor whiteColor].CGColor;
        //clippingRegionView.backgroundColor = [UIColor redColor];
        //clippingRegionView.alpha = 0.5;
        return clippingRegionView;
    }];
    if (self) {
        // CJMaskImageAdjustGRView的方法：添加蒙层
        [self addMaskLayerWithRectPathType:CJRectPathTypeRectangle opacity:1.0]; // 默认遮住不显示裁剪框外的区域
        
        // CJAdjustGRView的方法：设置拖动和捏合缩放等手势状态发生变化的回调(内部已处理完位置调整等操作)
        [self setupExtraPanStateChangeBlock:^(UIGestureRecognizerState panGRState) {
            if(panGRState == UIGestureRecognizerStateBegan) {
                [self showOther:YES];
            } else if (panGRState == UIGestureRecognizerStateChanged) {
                
            } else if (panGRState == UIGestureRecognizerStateEnded) {
                [self showOther:NO];
            }
        } pinchStateChangeBlock:^(UIGestureRecognizerState pinchGRState, CGFloat pinchScale) {
            if(pinchGRState == UIGestureRecognizerStateBegan) {
                [self showOther:YES];
            } else if (pinchGRState == UIGestureRecognizerStateChanged) {
                
            } else if (pinchGRState == UIGestureRecognizerStateEnded) {
                [self showOther:NO];
            }
        }];
    }
    return self;
}


#pragma mark - Event
/// 是否显示照片的呗遮挡区域
- (void)showOther:(BOOL)show {
    self.maskLayer.opacity = show ? 0.4 : 1.0;
    self.clippingRegionView.layer.borderWidth = show ? 0.5 : 0;
    self.clippingRegionView.layer.borderColor = [UIColor whiteColor].CGColor;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
