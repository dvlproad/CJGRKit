//
//  TSAnyGRViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/05.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "TSAnyGRViewController.h"
#import <CQDemoKit/CJUIKitRandomUtil.h>
#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJCornerGR.h>

@interface TSAnyGRViewController () {
    UILabel *redLabel;
    UILabel *blueLabel;
    UILabel *greenLabel;
}

@end

@implementation TSAnyGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"UIView+CJAnyGR 手势验证", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewWidth = 120;
    CGFloat viewHeight = 90;
    CGFloat gap = 50;
    CGFloat centerX = CGRectGetMidX(self.view.bounds);
    
    // 1. 只加拖动
    UIView *redView = [self __createColorViewWithTitle:@"只拖动" color:[UIColor systemRedColor]];
    redView.frame = CGRectMake(centerX - viewWidth/2, 110, viewWidth, viewHeight);
    [self.view addSubview:redView];
    [redView cj_addPanGR];
    
    // 2. 拖动 + 缩放
    UIView *blueView = [self __createColorViewWithTitle:@"拖动+缩放" color:[UIColor systemBlueColor]];
    blueView.frame = CGRectMake(centerX - viewWidth/2, CGRectGetMaxY(redView.frame) + gap, viewWidth, viewHeight);
    [self.view addSubview:blueView];
    [blueView cj_addPanGR];
    [blueView cj_addPinchGR];
    
    // 3. 拖动 + 缩放 + 旋转
    UIView *greenView = [self __createColorViewWithTitle:@"拖动+缩放+旋转" color:[UIColor systemGreenColor]];
    greenView.frame = CGRectMake(centerX - viewWidth/2, CGRectGetMaxY(blueView.frame) + gap, viewWidth, viewHeight);
    [self.view addSubview:greenView];
    [greenView cj_addPanGR];
    [greenView cj_addPinchGR];
    [greenView cj_addRotationGR];
    
    // 4. 只加边框 + 角按钮（右下操作柄直接驱动缩放旋转）
    UIView *orangeView = [self __createColorViewWithTitle:@"只对角按钮加手势" color:[UIColor systemOrangeColor]];
    orangeView.frame = CGRectMake(centerX - viewWidth/2, CGRectGetMaxY(greenView.frame) + gap, viewWidth, viewHeight);
    [self.view addSubview:orangeView];
    [orangeView cj_setCornerBorderWithColor:[UIColor blackColor]];
    [orangeView cj_addCornerDeleteButtonWithBlock:^(UIView *view) {
        [view removeFromSuperview];
    }];
    [orangeView cj_addCornerUpdateButtonWithBlock:^(UIView *view) {
        view.backgroundColor = [CJUIKitRandomUtil randomColorWithAlpha:1.0];
    }];
    [orangeView cj_addCornerMinimizeHandle];
    
    // 5. 全部操作：拖动 + 缩放 + 旋转 + 角按钮
    UIView *purpleView = [self __createColorViewWithTitle:@"全部操作" color:[UIColor systemPurpleColor]];
    purpleView.frame = CGRectMake(centerX - viewWidth/2, CGRectGetMaxY(orangeView.frame) + gap, viewWidth, viewHeight);
    [self.view addSubview:purpleView];
    [purpleView cj_addPanGR];
    [purpleView cj_addPinchGR];
    [purpleView cj_addRotationGR];
    [purpleView cj_setCornerBorderWithColor:[UIColor blackColor]];
    [purpleView cj_addCornerDeleteButtonWithBlock:^(UIView *view) {
        [view removeFromSuperview];
    }];
    [purpleView cj_addCornerUpdateButtonWithBlock:^(UIView *view) {
        view.backgroundColor = [CJUIKitRandomUtil randomColorWithAlpha:1.0];
    }];
    [purpleView cj_addCornerMinimizeHandle];
}

- (UIView *)__createColorViewWithTitle:(NSString *)title color:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.layer.cornerRadius = 12;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowOpacity = 0.3;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [label.leadingAnchor constraintGreaterThanOrEqualToAnchor:view.leadingAnchor constant:8],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:view.trailingAnchor constant:-8],
    ]];
    
    return view;
}

@end
