//
//  CJImageNormalAdjustGRView.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//

#import "CJImageNormalAdjustGRView.h"
#import "CGRectCJSubHelper.h"       // 用于裁剪区域及拖动限制区域的获取

@interface CJImageNormalAdjustGRView () {
    
}

@end

@implementation CJImageNormalAdjustGRView

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
    CJImageNormalAdjustGRView *view = [super initWithSubViewCreateBlock:^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES; // 超出部分截取
        imageView.contentMode = contentMode;
        return imageView;
    } clippingViewCreateBlock:nil];
    
    return view;
}

#pragma mark - Get
- (UIImageView *)imageView {
    return self.scaleShowView;
}

#pragma mark - Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}


#pragma mark - Update
//- (void)updateImage:(UIImage *)image {
//    [[self imageView] setImage:image];
////    _hasSetFrameForThisImage = NO;
//
//    [self updateFrameByImage:image];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    //NSLog(@"%@：layoutSubviews...", NSStringFromClass([self class]));
    
    if (self.hasSetFrameForThisImage == NO) {
        UIImage *image = [self imageView].image;
        if (image == nil) {
            NSLog(@"未设置图片，内容将为空");
            return;
        }
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

    CGRect showViewOriginFrame = CGRectMake(0, 0, width, height);
    self.clippingFrame = showViewOriginFrame; // 裁剪框的frame（拖动时候用来限制范围，缩放时候用来限制大小）
    
    
    // UIViewContentModeScaleAspectFill 的时候
    CGFloat minShowFrameMinWidth = width;
    CGFloat minShowFrameMinHeight = height;
    
    [self updateImageViewFrameByImage:image
                 minShowFrameMinWidth:minShowFrameMinWidth
                minShowFrameMinHeight:minShowFrameMinHeight];
}


/*
 *  更新图片视图初始显示占用的frame（这里保持图片的宽高比，来调整缩放图片该占有的frame）
 *
 *  @param image                        当前的图片
 *  @param minShowFrameMinWidth         保持图片比例，图片显示的最小宽不能小于的值
 *  @param minShowFrameMinHeight        保持图片比例，图片显示的最小高不能小于的值
 */
- (void)updateImageViewFrameByImage:(UIImage *)image
               minShowFrameMinWidth:(CGFloat)minShowFrameMinWidth
              minShowFrameMinHeight:(CGFloat)minShowFrameMinHeight
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width == 0 || height == 0) {
        //NSLog(@"视图宽高还未渲染出来");
        return;
    }
    
    if (image == nil) {
        NSLog(@"错误提示：都执行到此步了，image不应该为空");
        return;
    }
    CGFloat minShowFrameRatio = image.size.width/image.size.height; // 显示视图的比例（这里保持图片的宽高比，来调整缩放图片该占有的frame）
    CGRect minShowFrame = [CGRectCJSubHelper getMinSubFrameWithRatio:minShowFrameRatio
                                                            minWidth:minShowFrameMinWidth
                                                           minHeight:minShowFrameMinHeight
                                                         inCageFrame:self.frame
                                                     subFramePositon:YES];
    [self updateScaleShowViewOriginFrame:minShowFrame]; // 内容显示的frame
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
