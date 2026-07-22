//
//  CJGRScrollView.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/3.
//

#import "CJGRScrollView.h"
#import <Masonry/Masonry.h>

@interface CJGRScrollView () {
    
}
@property (nonatomic, copy, readonly) UIView *(^ _Nullable clippingViewCreateBlock)(void);  /**< 裁剪框的创建(可以为nil) */
@property (nullable, nonatomic, strong) UIView *clippingRegionView; /**< 裁剪框视图（可以为nil） */

@end

@implementation CJGRScrollView

#pragma mark - Init
/*
 *  初始化
 *
 *  @param subViewCreateBlock       用来展示缩放拖动效果的视图的创建（不可以为nil）
 *  @param clippingViewCreateBlock  裁剪框的创建(可以为nil)
 *
 *  @return 可缩放子视图大小和调整子视图位置的视图
 */
- (instancetype)initWithSubViewCreateBlock:(UIView *(^ _Nonnull)(void))subViewCreateBlock
                   clippingViewCreateBlock:(UIView *(^ _Nullable)(void))clippingViewCreateBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
//        _panStateChangeBlock = panStateChangeBlock;
//        _pinchStateChangeBlock = pinchStateChangeBlock;
        self.layer.masksToBounds = YES; // 超出视图部分截掉
        [self commonInit];
        
        NSAssert(subViewCreateBlock != nil, @"用来展示缩放拖动效果的视图的创建方法不能为空");
        UIView *scaleShowView = subViewCreateBlock();
        [self.containerView addSubview:scaleShowView];
        [scaleShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        _scaleShowView = scaleShowView;
        
        //scaleShowView.backgroundColor = [UIColor purpleColor];
        //[scaleShowView setFrame:CGRectMake(10, 10, 100, 100)];
        
        [self addTapGesture];
    }
    return self;
}

- (void)commonInit {
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1.0;
    self.multipleTouchEnabled = YES;
    self.delegate = self;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.alwaysBounceVertical = NO;
    
    UIView *containerView = [[UIView alloc] init];
    //containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height).mas_offset(1);
    }];
    self.containerView = containerView;
}


- (void)addTapGesture {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - Setter
- (void)setPinchMaxScale:(CGFloat)pinchMaxScale {
    _pinchMaxScale = pinchMaxScale;
    
    self.maximumZoomScale = pinchMaxScale;
}


#pragma mark - 单击手势
- (void)singleTap:(UITapGestureRecognizer *)tap {
//    if ([self.delegate respondsToSelector:@selector(singleTapAction)]) {
//        [self.delegate singleTapAction];
//    }
}


#pragma mark - 双击手势
- (void)doubleTap:(UITapGestureRecognizer *)tap {
//    if (_scrollView.zoomScale > 1.0) {
//        [_scrollView setZoomScale:1.0 animated:YES];
//    } else {
//
//        CGPoint touchPoint = [tap locationInView:_imageView];
//        CGFloat newZoomScale = _scrollView.maximumZoomScale;
//        CGFloat xsize = [[UIScreen mainScreen] bounds].size.width / newZoomScale;
//        CGFloat ysize = [[UIScreen mainScreen] bounds].size.height / newZoomScale;
//        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
//    }
}


#pragma mark - 长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
//    if (_player.isSliderTouch) return;
//    switch (longPress.state) {
//        case UIGestureRecognizerStateBegan:
//            if ([self.delegate respondsToSelector:@selector(longPressActionAtCollectionViewCell:)]) {
//                [self.delegate longPressActionAtCollectionViewCell:self];
//            }
//            break;
//
//        default:
//            break;
//    }
}



#pragma mark - UIScrollViewDelegate
//返回一个允许缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
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
//    [self showOccludedView:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self showOccludedView:YES];
}

#pragma mark UIScrollViewDelegate：缩放
//缩放时调用，更新布局，视图顶格贴边展示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.containerView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    [self showOccludedView:NO];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    [self showOccludedView:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
