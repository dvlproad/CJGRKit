//
//  CQMaskCenterView.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/4.
//

#import "CQMaskCenterView.h"
#import <Masonry/Masonry.h>
#import <CJGRKit/CJImageGRScrollView.h>

@interface CQMaskCenterView () <UIScrollViewDelegate> {
    
}
@property (nonatomic, strong) CJGRScrollView *scrollView;
@property (nonatomic, strong) UIView *occludedTopView;
@property (nonatomic, strong) UIView *occludedBottomView;

@end


@implementation CQMaskCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)showOccludedView:(BOOL)show {
    CGFloat alpha = show ? 0.3 : 0;
    self.occludedTopView.alpha = alpha;
    self.occludedBottomView.alpha = alpha;
}


- (void)setupViews {
    
    
    
    //底部灰色的view
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.7;
    [self addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    
    
    
    
    //贝塞尔曲线 画一个矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    //矩形镂空的部分
    CGRect ovalRect = CGRectMake(100, 100, 200, 70);
    UIBezierPath *ovalPath = [[UIBezierPath bezierPathWithOvalInRect:ovalRect] bezierPathByReversingPath];
    [bpath appendPath:ovalPath];
    //椭圆
//    UIBezierPath *squarePath = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kSCREEN_WIDTH - 100, 64, 100, 40) cornerRadius:2.0]bezierPathByReversingPath];
//    [bpath appendPath:squarePath];
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    //添加图层蒙板
    maskView.layer.mask = shapeLayer;
    
    CJImageGRScrollView *scrollView = [[CJImageGRScrollView alloc] initWithContentMode:UIViewContentModeScaleAspectFill];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.scrollView = scrollView;
//    self.scrollView.layer.mask = shapeLayer;
}


#pragma mark - UIScrollViewDelegate
//返回一个允许缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scrollView.containerView;
}

#pragma mark UIScrollViewDelegate：滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self showOccludedView:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    [self showOccludedView:YES];
}

#pragma mark UIScrollViewDelegate：多动Drag
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self showOccludedView:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self showOccludedView:YES];
}

#pragma mark UIScrollViewDelegate：缩放
//缩放时调用，更新布局，视图顶格贴边展示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.scrollView.containerView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [self showOccludedView:NO];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self showOccludedView:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
