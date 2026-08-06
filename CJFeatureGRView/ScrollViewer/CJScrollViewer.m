//
//  CJScrollViewer.m
//  CJFeatureGRView
//
//  Created by dvlproad on 2026/08/07.
//

#import "CJScrollViewer.h"

/// 下拉关闭触发阈值（contentOffset.y 小于该值触发）
static const CGFloat kCJViewerGRDragDownThreshold = 80.0;

@interface CJScrollViewer () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL dragDownCloseTriggered;  // 本次下拉是否已触发过关闭（回弹后重置）

@end

@implementation CJScrollViewer

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxScale = 3.0;
        
        self.delegate = self;
        self.multipleTouchEnabled = YES;
        self.bouncesZoom = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = YES;   // 允许下拉（contentOffset.y 可为负）以支持下拉关闭
        
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        _contentView = contentView;
        
        [self addTapGestures];
    }
    return self;
}

- (void)addTapGestures {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - Setter

- (void)setMaxScale:(CGFloat)maxScale {
    _maxScale = maxScale;
    self.maximumZoomScale = maxScale;
}

#pragma mark - 手势处理

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    !self.singleTapBlock ?: self.singleTapBlock();
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    // 已在放大态 → 还原到最小缩放
    if (self.zoomScale > self.minimumZoomScale + 0.001) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
        return;
    }
    // 放大到 maxScale，缩放中心 = 点击点
    CGFloat newScale = self.maxScale;
    if (newScale < self.minimumZoomScale) {
        newScale = self.minimumZoomScale;
    }
    CGPoint touchPoint = [tap locationInView:self.contentView];
    CGFloat w = self.bounds.size.width / newScale;
    CGFloat h = self.bounds.size.height / newScale;
    [self zoomToRect:CGRectMake(touchPoint.x - w / 2.0, touchPoint.y - h / 2.0, w, h) animated:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        !self.longPressBlock ?: self.longPressBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

// 缩放时保持内容居中（内容小于视口时贴边居中）
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.contentView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

// 下拉关闭：放大态不响应；滚动中 contentOffset.y 低于阈值触发一次，回弹后重置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > scrollView.minimumZoomScale + 0.001) {
        return;
    }
    if (scrollView.contentOffset.y < -kCJViewerGRDragDownThreshold) {
        if (!self.dragDownCloseTriggered) {
            self.dragDownCloseTriggered = YES;
            !self.dragDownCloseBlock ?: self.dragDownCloseBlock();
        }
    } else if (scrollView.contentOffset.y >= 0) {
        self.dragDownCloseTriggered = NO;
    }
}

@end
