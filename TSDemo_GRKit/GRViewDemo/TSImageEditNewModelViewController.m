//
//  TSImageEditNewModelViewController.m
//  CJViewGRDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

#import "TSImageEditNewModelViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import "TSImageSourceUtil.h"
#import <CJGRKit/UIView+CJGR.h>
#import <CJGRKit/UIView+CJKeepCoveredBounds.h>

@interface TSImageEditNewModelViewController ()

@property (nonatomic, strong) UIView *editArea;            // 黑色编辑区
@property (nonatomic, strong) UIView *cropOverlayView;    // 裁剪窗口标记：半透明红方块（盖在内容上，对齐旧 clippingRegionView）
@property (nonatomic, strong) UIImageView *contentView;    // 内容：图片本身（第一公民）
@property (nonatomic, assign) CGRect cropRect;             // 裁剪窗口（editArea 坐标系）
@property (nonatomic, assign) BOOL didSetupOnce;

@end

@implementation TSImageEditNewModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"新模型：图片裁剪(内容+GR+Clip)", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    
    // 选图
    CQTSRadioButtonsView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"竖直长图", @"水平宽图", @"随机图"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        UIImage *image = nil;
        switch (index) {
            case 0: image = [TSImageSourceUtil longVertical01]; break;
            case 1: image = [TSImageSourceUtil longHorizontal01]; break;
            case 2: image = [TSImageSourceUtil localImageRandom]; break;
        }
        [weakSelf updateContentImage:image];
    }];
    [self.view addSubview:buttonsView];
    
    // 重置（自由拖动可能把内容拖出窗口，提供一键恢复）
    UIButton *resetButton = [CQTSButtonFactory themeBGButtonWithTitle:@"重置(居中恢复)" actionBlock:^(UIButton * _Nonnull bButton) {
        [weakSelf resetContentLayout];
    }];
    [self.view addSubview:resetButton];
    
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.height.mas_equalTo(44);
    }];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-10);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    // 编辑区（对齐旧 CJGRView：黑色 + clipsToBounds 裁内容到编辑区边界）
    UIView *editArea = [[UIView alloc] init];
    editArea.backgroundColor = [UIColor blackColor];
    editArea.clipsToBounds = YES;
    [self.view addSubview:editArea];
    self.editArea = editArea;
    [editArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(20);
        make.bottom.mas_equalTo(resetButton.mas_top).mas_offset(-20);
    }];
    
    // 内容：图片本身（frame 定位，手势拖动改 center，不能用 Auto Layout 约束）
    UIImageView *contentView = [[UIImageView alloc] init];
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    contentView.layer.masksToBounds = YES;
    contentView.userInteractionEnabled = YES;   // UIImageView 默认 NO，不开则手势收不到触摸
    [editArea addSubview:contentView];
    self.contentView = contentView;
    
    // 裁剪窗口标记：半透明红色方块盖在内容上方（对齐旧 clippingRegionView 红 alpha 0.5，仅展示不拦截触摸）
    UIView *cropOverlayView = [[UIView alloc] init];
    cropOverlayView.backgroundColor = [UIColor redColor];
    cropOverlayView.alpha = 0.5;
    cropOverlayView.userInteractionEnabled = NO;
    [editArea addSubview:cropOverlayView];
    self.cropOverlayView = cropOverlayView;
    
    // 正交独立手势：拖动 + 捏合缩放
    [contentView cj_addPanGR];
    [contentView cj_addPinchGR];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.didSetupOnce) {
        return;
    }
    CGRect editBounds = self.editArea.bounds;
    if (CGRectIsEmpty(editBounds)) {
        return;
    }
    self.didSetupOnce = YES;
    
    // 裁剪窗口：居中最大 1:1 正方形（对齐旧 getMaxSubFrameWithRatio:1/1.0，不实体化，仅用于展示覆盖层 + 约束）
    CGFloat side = MIN(CGRectGetWidth(editBounds), CGRectGetHeight(editBounds));
    self.cropRect = CGRectMake((CGRectGetWidth(editBounds)-side)/2,
                               (CGRectGetHeight(editBounds)-side)/2,
                               side, side);
    
    // 裁剪窗口展示：半透明红方块盖在内容上方（对齐旧 clippingRegionView）
    self.cropOverlayView.frame = self.cropRect;
    
    // 行为约束：内容 rect 覆盖裁剪窗口、手势结束吸附回合法域
    [self.contentView cj_setKeepCoveredRect:self.cropRect];
    
    // 初始内容
    [self updateContentImage:[TSImageSourceUtil localImageRandom]];
}

#pragma mark - Content

- (void)updateContentImage:(UIImage *)image {
    self.contentView.image = image;
    [self resetContentLayout];
}

/// 重置内容布局：按图片原始比例放大到能覆盖裁剪窗口，居中（覆盖窗口，拖动可看到图片所有部分）
- (void)resetContentLayout {
    CGRect cropRect = self.cropRect;
    if (CGRectIsEmpty(cropRect) || self.contentView.image == nil) {
        return;
    }
    UIImage *image = self.contentView.image;
    CGFloat coverScale = MAX(CGRectGetWidth(cropRect)/image.size.width,
                             CGRectGetHeight(cropRect)/image.size.height) * 1.5;
    CGSize contentSize = CGSizeMake(image.size.width*coverScale, image.size.height*coverScale);
    // 用 bounds+center 设置（与 transform 缩放解耦），再重置缩放
    self.contentView.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.contentView.center = CGPointMake(CGRectGetMidX(cropRect), CGRectGetMidY(cropRect));
    [self.contentView cj_setGRScale:1];
}

@end
