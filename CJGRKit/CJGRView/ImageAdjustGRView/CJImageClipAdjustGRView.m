//
//  CJImageClipAdjustGRView.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//

#import "CJImageClipAdjustGRView.h"
#import "CGRectCJSubHelper.h"       // 用于裁剪区域及拖动限制区域的获取

@interface CJImageClipAdjustGRView () {
    
}

@end

@implementation CJImageClipAdjustGRView

#pragma mark - Init
/*
 *  初始化
 *
 *  @param clippingViewCreateBlock  裁剪框的创建(可以为nil)
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithClippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock
{    
    CJImageClipAdjustGRView *view = [super initWithSubViewCreateBlock:^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES; // 超出部分截取
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    } clippingViewCreateBlock:clippingViewCreateBlock];
    
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


/*
 *  获取要裁剪/处在裁剪区域clippingFrame中的图片像素区域：使用场景图片裁剪
 *
 *  @return 与裁剪区域clippingFrame相交/重叠的那部分显示视图frame
 */
- (CGRect)getClippingPixelRect {
    CGRect overlappingShowFrame = [self getOverlappingShowFrame];
    
    //把点rect 转化为像素rect
    //CGFloat errorScale = [UIScreen mainScreen].scale;
    CGFloat imageViewFrameWidth = CGRectGetWidth(self.imageView.frame);
    UIImage *image = self.imageView.image;
    CGFloat scale = (imageViewFrameWidth /image.size.width);
    
    CGFloat x = overlappingShowFrame.origin.x/scale;
    CGFloat y = overlappingShowFrame.origin.y/scale;
    CGFloat w = overlappingShowFrame.size.width/scale;
    CGFloat h = overlappingShowFrame.size.height/scale;
    CGRect overlappingPixelRect = CGRectMake(x, y, w, h);
    
    return overlappingPixelRect;
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



/*
 *  根据得到的图片，在保持其比例的情况下，更新图片所占的frame（请在每次得到图片的时候调用此方法）
 *
 *  @param image 通过imageName或imageUrl等得到的图片
 */
- (void)updateFrameByImage:(UIImage *)image {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width == 0 || height == 0) {
        //NSLog(@"视图宽高还未渲染出来");
        return;
    }

    CGFloat clippingFrameRatio = 1/1.0; // 裁剪框的比例
    CGRect clippingFrame = [CGRectCJSubHelper getMaxSubFrameWithRatio:clippingFrameRatio inCageFrame:self.frame subFramePositon:YES];
    self.clippingFrame = clippingFrame; // 裁剪框的frame（拖动时候用来限制范围，缩放时候用来限制大小）

        
    [self updateImageViewFrameByClippingFrame:clippingFrame];
}

/*
 *  更新frame
 *
 *  @param image                image
 *  @param clippingFrame        裁剪框的frame（拖动时候用来限制范围，缩放时候用来限制大小），可以设置为CGRectZero，表示可任意移动
 */
- (void)updateImageViewFrameByClippingFrame:(CGRect)clippingFrame {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (width == 0 || height == 0) {
        //NSLog(@"视图宽高还未渲染出来");
        return;
    }

    // UIViewContentModeScaleAspectFill 的时候
    CGFloat minShowFrameMinWidth;
    CGFloat minShowFrameMinHeight;
    if (CGRectEqualToRect(clippingFrame, CGRectZero) == NO) {
        minShowFrameMinWidth = CGRectGetWidth(clippingFrame);
        minShowFrameMinHeight = CGRectGetHeight(clippingFrame);
    } else {
        minShowFrameMinWidth = width;
        minShowFrameMinHeight = height;
    }
    
    UIImage *image = self.imageView.image;
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
