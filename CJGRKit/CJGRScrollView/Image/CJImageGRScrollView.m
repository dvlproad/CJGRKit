//
//  CJImageGRScrollView.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/3.
//

#import "CJImageGRScrollView.h"
#import <CJGRKit/CGRectCJSubHelper.h>

@implementation CJImageGRScrollView

#pragma mark - Init
/*
 *  初始化
 *
 *  @param contentMode  contentMode
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithContentMode:(UIViewContentMode)contentMode
{
    self = [super initWithSubViewCreateBlock:^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES; // 超出部分截取
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    } clippingViewCreateBlock:nil];
    
    self.contentMode = contentMode;
    
    return self;
}

#pragma mark - Get
- (UIImageView *)imageView {
    return self.scaleShowView;
}


#pragma mark - Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;

    _hasSetFrameForThisImage = NO;

    [self updateFrameByImage:image];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //NSLog(@"%@：layoutSubviews...", NSStringFromClass([self class]));
    
    if (self.hasSetFrameForThisImage == NO) {
        UIImage *image = [self imageView].image;
        [self updateFrameByImage:image];
    }
}



- (void)updateFrameByImage:(UIImage *)image {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width == 0 || height == 0) {
        //NSLog(@"视图宽高还未渲染出来");
        return;
    }
    
    if (self.hasSetFrameForThisImage == NO) {
        CGFloat widthHeightRatio = image.size.width/image.size.height;
        CGSize minSize = [CGRectCJSubHelper getMinSizeWithRatio:widthHeightRatio
                                                       minWidth:width
                                                      minHeight:height];
        CGFloat widthScale = minSize.width/width;
        CGFloat heightScale = minSize.height/height;
        if (self.contentMode == UIViewContentModeScaleAspectFill) {
            self.zoomScale = MAX(widthScale, heightScale);
        } else {
            self.zoomScale = 1.0;
        }
        _hasSetFrameForThisImage = YES;
    }
    
}


@end
