//
//  CQMaskCenterView.h
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQMaskCenterView : UIView {
    
}
@property (nonatomic, strong) UIImage *image;   // 要裁剪的图片（请在 init 后设置)


- (void)showOccludedView:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
