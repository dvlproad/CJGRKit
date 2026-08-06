//
//  TSGRKeepCoveredBoundsViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "TSGRKeepCoveredBoundsViewController.h"
#import "TSImageSourceUtil.h"
#import <Masonry/Masonry.h>
#import <CJGRKit/UIView+CJAnyGR.h>
#import <CJGRKit/UIView+CJKeepCoveredBounds.h>

@interface TSGRKeepCoveredBoundsViewController ()

@end

@implementation TSGRKeepCoveredBoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"UIView+CJKeepCoveredBounds 外方向约束验证", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat windowWidth = 340;
    CGFloat windowHeight = 250;
    
    // 裁剪窗口：固定取景框，由宿主负责显示裁剪（容器 clipsToBounds），CJKeepCoveredBounds 只做行为约束
    UIView *clipContainer = [[UIView alloc] init];
    clipContainer.backgroundColor = [UIColor blackColor];
    clipContainer.layer.borderColor = [UIColor systemGrayColor].CGColor;
    clipContainer.layer.borderWidth = 2;
    clipContainer.clipsToBounds = YES;
    [self.view addSubview:clipContainer];
    
    // 内容视图：按图片原始比例放大到能覆盖窗口，拖动时能看到图片所有部分
    //（若内容视图尺寸比例与图片不一致 + ScaleAspectFill，图片会被裁切，永远看不到被裁掉的部分）
    // 注意：内容视图是手势作用对象（拖动改 center），必须用 frame 定位，不能用 Auto Layout 约束
    //（center 约束会在 layout 时把手动设置的 center 重置回约束位置，导致拖不动）
    UIImage *clipImage = [TSImageSourceUtil localImageRandom];
    CGSize imageSize = clipImage.size;
    CGFloat coverScale = MAX(windowWidth / imageSize.width, windowHeight / imageSize.height) * 1.5;
    CGFloat contentWidth = imageSize.width * coverScale;
    CGFloat contentHeight = imageSize.height * coverScale;
    UIView *clipContent = [[UIView alloc] initWithFrame:CGRectMake((windowWidth - contentWidth)/2,
                                                                   (windowHeight - contentHeight)/2,
                                                                   contentWidth, contentHeight)];
    [clipContainer addSubview:clipContent];
    
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
    
    // 规则说明
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = [@[
        @"规则：",
        @"• 拖动：可自由拖出窗口",
        @"• 捏合：可自由缩放",
        @"• 松手：自动吸附回「覆盖窗口」的合法域",
    ] componentsJoinedByString:@"\n"];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:tipLabel];
    
    // 布局：裁剪窗口 340×250 居中偏上（Masonry），内容 1.5 倍覆盖窗口（frame），规则说明在窗口下方
    [clipContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(120);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(250);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clipContainer.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(30);
        make.trailing.equalTo(self.view).offset(-30);
    }];
    
    [self.view layoutIfNeeded];
    [clipContent cj_setKeepCoveredRect:clipContainer.bounds];
}

@end
