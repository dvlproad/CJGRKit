//
//  TSGRSuspendLogoView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/07.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "TSGRSuspendLogoView.h"
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJKeepInBounds.h>

@implementation TSGRSuspendLogoView

+ (instancetype)show {
    TSGRSuspendLogoView *logoView = [[TSGRSuspendLogoView alloc] init];
    logoView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:logoView];
    return logoView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 70, 70);
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
        [self setupViews];
        [self setupDragAndAdsorb];
    }
    return self;
}

- (void)setupViews {
    // 随机背景图
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    
    // 背景按钮：点击关闭
    UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.frame = self.bounds;
    [backgroundButton setBackgroundImage:localImageRandom forState:UIControlStateNormal];
    [backgroundButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundButton];
    
    // 右上角关闭按钮
    UIButton *closeXButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeXButton setTitle:@"✕" forState:UIControlStateNormal];
    closeXButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    closeXButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 26, 0, 26, 26);
    closeXButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    closeXButton.layer.cornerRadius = 13;
    closeXButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    closeXButton.layer.borderWidth = 0.5;
    [closeXButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeXButton];
}

- (void)setupDragAndAdsorb {
    [self cj_addPanGR];
    __weak typeof(self) weakSelf = self;
    self.cjGRStateChangeBlock2 = ^(CJGRType type, UIGestureRecognizerState state) {
        if (state == UIGestureRecognizerStateEnded ||
            state == UIGestureRecognizerStateCancelled) {
            [weakSelf cjKeepBoundsWithBoundEdgeInsets:UIEdgeInsetsMake(64, 20, 0, 20)
                     isKeepBoundsXYWhenBeyondBound:YES
                  isKeepBoundsXWhenContaintInBound:YES
                  isKeepBoundsYWhenContaintInBound:NO];
            [CJUIKitToastUtil showMessage:@"拖动结束"];
        }
    };
}

- (void)closeSelf {
    [self removeFromSuperview];
}

@end
