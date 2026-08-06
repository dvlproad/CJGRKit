//
//  TSImageNormalAdjustGRViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSImageNormalAdjustGRViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import "TSImageSourceUtil.h"
#import <CJFeatureGRView/CJImageAdjustGRView.h>

@interface TSImageNormalAdjustGRViewController () {
    
}
@property (nonatomic, strong) CJImageAdjustGRView *editView;   // 完整组件：内容(第一公民) + 内置手势 + 裁剪窗口约束

@end

@implementation TSImageNormalAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"图片视图(普通)：缩放+位置调整(CJImageAdjustGRView完整组件)", nil);
    
    __weak typeof(self) weakSelf = self;
    CQTSRadioButtonsView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"场景1(约束取景式)：\n内容覆盖编辑区，手势结束吸附", @"场景2(无约束摆放式)：\n关闭吸附约束(贴纸/多元素自由定位)"] alongAxis:MASAxisTypeVertical fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        if (index == 0) {
            [weakSelf useType1];
        } else {
            [weakSelf useType2];
        }
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(60*2+10*1);   // 标题两行，按钮高度给足
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    UIView *imageButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"竖直长图", @"水平宽图"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        UIImage *image = index == 0 ? [TSImageSourceUtil longVertical01] : [TSImageSourceUtil longHorizontal01];
        [weakSelf updateContentImage:image];
    }];
    [self.view addSubview:imageButtonsView];
    [imageButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-10);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    // 编辑区：黑底完整组件（内置拖动/捏合手势 + 裁剪窗口约束），开箱即用
    CJImageAdjustGRView *editView = [[CJImageAdjustGRView alloc] initWithBackgroundColor:[UIColor blackColor]];
    editView.maxScale = 2;   // 对齐旧 pinchMaxScale=2
    editView.image = [TSImageSourceUtil longVertical01];
    [self.view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(20);
        make.bottom.mas_equalTo(imageButtonsView.mas_top).mas_offset(-20);
    }];
    self.editView = editView;
    
    // 默认选中场景1(编辑式)，保持 UI 高亮与初始状态一致
    [buttonsView didSelectItemAtIndex:0];
}

#pragma mark - 场景

// 场景1：约束取景式（内容覆盖编辑区，KeepCovered 约束手势结束吸附）——对齐旧 CJImageNormalAdjustGRView 的 clippingFrame=全视图
// 组件默认即盖满编辑区（cropRectCoversBounds=YES），切回此场景仅重置布局
- (void)useType1 {
    self.editView.keepCoveredEnabled = YES;
    [self.editView updateFrameByImage:self.editView.image];  // 重置为最小覆盖编辑区，居中（对齐原 resetContentLayoutToCoverRect）
}

// 场景2：无约束摆放（关闭 KeepCovered 吸附，内容自由拖动/缩放，仍可输出 getClippingPixelRect 结果）
// 用途：贴纸/文字/多元素/自定义构图（内容无需盖满窗口）；查看需求请用 LookGR 的 CJImageScrollViewer
- (void)useType2 {
    self.editView.keepCoveredEnabled = NO;
    [self.editView updateFrameByImage:self.editView.image];  // 重置为最小覆盖编辑区，居中
}

#pragma mark - 内容操作

- (void)updateContentImage:(UIImage *)image {
    self.editView.image = image;   // setter 内部已更新布局（覆盖裁剪窗口并居中）
}

@end
