//
//  CJImageScrollViewer.m
//  CJFeatureGRView
//
//  Created by dvlproad on 2026/08/07.
//

#import "CJImageScrollViewer.h"

@interface CJImageScrollViewer ()

@property (nonatomic, assign) BOOL didLayoutForImage;   // 已为此图片完成初始布局

@end

@implementation CJImageScrollViewer

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.didLayoutForImage) {
        return;
    }
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    [self updateFrameByImage:self.imageView.image];
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    [self updateFrameByImage:image];
}

#pragma mark - 内容布局

- (void)updateFrameByImage:(UIImage *)image {
    if (image == nil) {
        return;
    }
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    // 内容视图 = 图片原始尺寸（point），通过 zoomScale 缩放显示
    self.contentView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    self.contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.imageView.frame = self.contentView.bounds;
    
    // 初始缩放：整图 fit 可见居中
    CGFloat fitScale = MIN(self.bounds.size.width / image.size.width,
                           self.bounds.size.height / image.size.height);
    self.minimumZoomScale = fitScale;
    self.maximumZoomScale = self.maxScale;
    self.zoomScale = fitScale;
    
    self.didLayoutForImage = YES;
}

@end
