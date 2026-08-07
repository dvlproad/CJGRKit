//
//  TSKeepInBoundsViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSKeepInBoundsViewController.h"
#import "TSGRSuspendLogoView.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/UIView+CQAuxiliaryText.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <Masonry/Masonry.h>

#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJKeepInBounds.h>

@interface TSKeepInBoundsViewController () {
    
}
@property (nonatomic, assign) NSInteger keepStrategyIndex;   // 0出界+界内都吸附 1仅出界吸附 2无约束

@end

@implementation TSKeepInBoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"可拖曳的View(内方向 KeepInBounds)", nil);
    
    // 单选：内方向吸附策略三档（切换只记录档位，下次松手按新档位吸附）
    __weak typeof(self) weakSelf = self;
    CQTSRadioButtonsView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[
        @"① 出界+界内都吸附\n拖出边界被拉回，界内松手也吸附归位",
        @"② 仅出界吸附\n界内自由摆放，拖出边界才被拉回",
        @"③ 无约束(对照)\n可自由拖出边界，不吸附",
    ] alongAxis:MASAxisTypeVertical fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.keepStrategyIndex = index;
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(60*3+10*2);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    // 红色(橙)视图：内方向吸附测试对象
    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(16, 182, 258, 220)];
    orangeView.backgroundColor = [UIColor colorWithRed:0.996 green:0.780 blue:0.369 alpha:1.0];
    [orangeView cqts_addPromptText:@"橙色view被限制在其父视图self.view中，出不来了!" layout:CQAuxiliaryAlignmentCenter height:44];
    [self.view addSubview:orangeView];
    [orangeView cj_addPanGR];
    orangeView.cjGRStateChangeBlock2 = ^(CJGRType type, UIGestureRecognizerState state) {
        if (state == UIGestureRecognizerStateEnded ||
            state == UIGestureRecognizerStateCancelled) {
            [weakSelf applyStrategyToView:orangeView];
        }
    };
    
    // 悬浮按钮：加到 keyWindow，演示 window 级内方向吸附（固定全吸附，不随单选）
    [TSGRSuspendLogoView show];
    
    // 默认选中策略①，保持 UI 高亮与初始状态一致
    [buttonsView didSelectItemAtIndex:0];
}

/// 按当前选中策略吸附（策略③无约束则不吸附）
- (void)applyStrategyToView:(UIView *)view {
    if (self.keepStrategyIndex == 0) {
        [view cjKeepBoundsWithBoundEdgeInsets:UIEdgeInsetsZero
               isKeepBoundsXYWhenBeyondBound:YES
            isKeepBoundsXWhenContaintInBound:YES
            isKeepBoundsYWhenContaintInBound:YES];
    } else if (self.keepStrategyIndex == 1) {
        [view cjKeepBoundsWithBoundEdgeInsets:UIEdgeInsetsZero
               isKeepBoundsXYWhenBeyondBound:YES
            isKeepBoundsXWhenContaintInBound:NO
            isKeepBoundsYWhenContaintInBound:NO];
    }
    [CJUIKitToastUtil showMessage:@"拖动结束"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
