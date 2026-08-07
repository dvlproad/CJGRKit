//
//  TSKeepCoveredBoundsViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "TSKeepCoveredBoundsViewController.h"
#import "TSImageSourceUtil.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJKeepCoveredBounds.h>

@interface TSKeepCoveredBoundsViewController ()

@property (nonatomic, strong) UIView *clipContainer;    // 裁剪窗口（宿主负责 clipsToBounds 展示裁剪）
@property (nonatomic, strong) UIView *clipContent;      // 内容视图（手势作用对象，frame 定位）
@property (nonatomic, strong) UILabel *tipLabel;        // 规则说明（随档位更新）
@property (nonatomic, assign) CGFloat baseCoverScale;   // 恰好覆盖窗口所需的倍率（×档位 = 实际覆盖力度）

@end

@implementation TSKeepCoveredBoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"UIView+CJKeepCoveredBounds 外方向约束验证", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 单选：覆盖力度三档（切换时重建内容视图）
    __weak typeof(self) weakSelf = self;
    CQTSRadioButtonsView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[
        @"① 1.5x 覆盖(充足)\n松手吸附只归位，内容始终盖住窗口",
        @"② 1.2x 覆盖\n同上，覆盖略紧",
        @"③ 0.9x 覆盖(不足)\n松手吸附自动放大到盖住窗口(外方向本质)",
    ] alongAxis:MASAxisTypeVertical fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        CGFloat scale = (index == 0) ? 1.5 : (index == 1) ? 1.2 : 0.9;
        [weakSelf setupClipContentWithScale:scale];
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(60*3+10*2);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    // 裁剪窗口：固定取景框，由宿主负责显示裁剪（容器 clipsToBounds），CJKeepCoveredBounds 只做行为约束
    UIView *clipContainer = [[UIView alloc] init];
    clipContainer.backgroundColor = [UIColor blackColor];
    clipContainer.layer.borderColor = [UIColor systemGrayColor].CGColor;
    clipContainer.layer.borderWidth = 2;
    clipContainer.clipsToBounds = YES;
    [self.view addSubview:clipContainer];
    self.clipContainer = clipContainer;
    
    [clipContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(250);
    }];
    
    // 规则说明（随档位更新）
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clipContainer.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(30);
        make.trailing.equalTo(self.view).offset(-30);
    }];
    
    // 计算恰好覆盖窗口的基准倍率，再按档位创建内容
    UIImage *clipImage = [TSImageSourceUtil localImageRandom];
    self.baseCoverScale = MAX(340.0 / clipImage.size.width, 250.0 / clipImage.size.height);
    
    [self setupClipContentWithScale:1.5];
    
    // 默认选中档位①，保持 UI 高亮与初始状态一致
    [buttonsView didSelectItemAtIndex:0];
}

/// 按覆盖力度创建/重建内容视图（内容视图用 frame 定位，不能用 Auto Layout 约束，否则拖动 center 会被重置）
- (void)setupClipContentWithScale:(CGFloat)scale {
    [self.clipContent removeFromSuperview];
    
    CGFloat windowWidth = CGRectGetWidth(self.clipContainer.bounds);
    CGFloat windowHeight = CGRectGetHeight(self.clipContainer.bounds);
    
    // 内容视图：按图片原始比例放大到能覆盖窗口（拖动时能看到图片所有部分）
    UIImage *clipImage = [TSImageSourceUtil localImageRandom];
    CGFloat coverScale = self.baseCoverScale * scale;
    CGFloat contentWidth = clipImage.size.width * coverScale;
    CGFloat contentHeight = clipImage.size.height * coverScale;
    UIView *clipContent = [[UIView alloc] initWithFrame:CGRectMake((windowWidth - contentWidth)/2,
                                                                   (windowHeight - contentHeight)/2,
                                                                   contentWidth, contentHeight)];
    [self.clipContainer addSubview:clipContent];
    self.clipContent = clipContent;
    
    UIImageView *clipImageView = [[UIImageView alloc] initWithImage:clipImage];
    clipImageView.frame = clipContent.bounds;
    clipImageView.contentMode = UIViewContentModeScaleAspectFill;
    [clipContent addSubview:clipImageView];
    
    [clipContent cj_addPanGR];
    [clipContent cj_addPinchGR];
    
    // 手势结束：触发外方向约束吸附（KeepCoveredBounds 不感知手势，由外部接线触发）
    __weak typeof(clipContent) weakClipContent = clipContent;
    clipContent.cjGRStateChangeBlock2 = ^(CJGRType type, UIGestureRecognizerState state) {
        if (state == UIGestureRecognizerStateEnded ||
            state == UIGestureRecognizerStateCancelled) {
            [weakClipContent cj_keepCoveredAdsorb];
        }
    };
    
    [self.clipContainer layoutIfNeeded];
    [clipContent cj_setKeepCoveredRect:self.clipContainer.bounds];
    [clipContent cj_keepCoveredAdsorb];
    
    // 规则说明随档位更新
    NSString *scaleDesc = (scale > 1.4) ? @"1.5x 充足覆盖：内容比窗口大，松手吸附主要归位。"
                         : (scale > 1.0) ? @"1.2x 覆盖：内容略大于窗口，松手吸附主要归位。"
                                         : @"0.9x 不足覆盖：内容小于窗口，松手吸附会把内容放大到盖住窗口（外方向保证内容 ⊃ 窗口的本质）。";
    self.tipLabel.text = [@[
        @"规则：",
        @"• 拖动：可自由拖出窗口",
        @"• 捏合：可自由缩放",
        @"• 松手：自动吸附回「覆盖窗口」的合法域",
        scaleDesc,
    ] componentsJoinedByString:@"\n"];
}

@end
