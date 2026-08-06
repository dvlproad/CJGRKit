//
//  TSMaskImageAdjustGRViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSMaskImageAdjustGRViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CQDemoKit/CQTSButtonFactory.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJFeatureGRView/CJMaskImageAdjustGRView.h>

#import "UIImage+CJClipUtil.h"
#import "TSMaskClipResultViewController.h"

@interface TSMaskImageAdjustGRViewController () {
    
}
@property (nonatomic, strong) CJMaskImageAdjustGRView *imageScaleView;   // 完整裁剪编辑组件（内置手势/约束/蒙层）

@end

@implementation TSMaskImageAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"图片视图(图片裁剪)：缩放+位置调整+蒙版(CJMaskImageAdjustGRView完整组件)", nil);
    
    __weak typeof(self) weakSelf = self;
    
    UIView *buttonsContainerView = [self buildButtonsContainerView];
    [self.view addSubview:buttonsContainerView];
    [buttonsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-10);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    // 完整裁剪编辑组件：内容(第一公民) + 内置手势/裁剪窗口约束/蒙层，开箱即用
    CJMaskImageAdjustGRView *imageScaleView = [[CJMaskImageAdjustGRView alloc] initWithBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:imageScaleView];
    [imageScaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(10);
        make.bottom.mas_equalTo(buttonsContainerView.mas_top).mas_offset(-10);
    }];
    self.imageScaleView = imageScaleView;
    
    // 内置捏合缩放上限（对齐旧 pinchMaxScale=2）
    imageScaleView.maxScale = 2;
    
    // 手势状态观察（组件内置了 showOther 联动，这里仅供外部联动示例）
    imageScaleView.grStateChangeBlock = ^(CJGRType type, UIGestureRecognizerState state) {
        // 示例：外部可在手势开始时做 UI 联动
    };
    
    // 初始图（组件内部 layoutSubviews 首次会自动按 cropRatio 生成裁剪窗口并完成初始布局，无需等布局完成）
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    [self updateContentImage:localImageRandom];
}

#pragma mark - Build

/// 单选按钮容器：后续要调整按钮时，只需改这个方法里的布局
- (UIView *)buildButtonsContainerView {
    __weak typeof(self) weakSelf = self;
    
    // 选图
    CQTSRadioButtonsView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"竖直长图", @"水平宽图", @"随机图"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        UIImage *image = nil;
        switch (index) {
            case 0:
                image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_vertical_1.jpg"];
                break;
            case 1:
                image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_horizontal_1.jpg"];
                break;
            case 2: {
                NSInteger trySelIndex = random();
                NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
                image = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
                break;
            }
        }
        [weakSelf updateContentImage:image];
    }];
    
    // 蒙层形状预览
    CQTSRadioButtonsView *maskButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"矩形预览", @"圆形预览"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.imageScaleView.shapeType = (index == 0 ? CJRectPathTypeRectangle : CJRectPathTypeCircle);
    }];
    
    // 框外蒙层透明度
    CQTSRadioButtonsView *opacityButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"框外隐藏", @"框外可见"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.imageScaleView.restMaskOpacity = (index == 0 ? 1.0 : 0.3); // 静止时框外蒙层透明度
    }];
    
    UIButton *clipButton = [CQTSButtonFactory themeBGButtonWithTitle:@"开始裁剪(注:裁剪非本示例测试点)" actionBlock:^(UIButton * _Nonnull bButton) {
        [weakSelf beginClip];
    }];
    
    UIView *buttonsContainerView = [[UIView alloc] init];
    [buttonsContainerView addSubview:buttonsView];
    [buttonsContainerView addSubview:maskButtonsView];
    [buttonsContainerView addSubview:opacityButtonsView];
    [buttonsContainerView addSubview:clipButton];
    
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(buttonsContainerView);
        make.height.mas_equalTo(44);
    }];
    [maskButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(buttonsView.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(buttonsContainerView);
        make.height.mas_equalTo(44);
    }];
    [opacityButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(maskButtonsView.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(buttonsContainerView);
        make.height.mas_equalTo(44);
    }];
    [clipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(opacityButtonsView.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(buttonsContainerView);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(buttonsContainerView);
    }];
    
    [maskButtonsView didSelectItemAtIndex:0]; // 默认选中"矩形预览"
    [opacityButtonsView didSelectItemAtIndex:0]; // 默认选中"框外隐藏"
    
    return buttonsContainerView;
}

#pragma mark - 内容操作

- (void)updateContentImage:(UIImage *)image {
    self.imageScaleView.image = image;   // setter 内部已更新布局（覆盖裁剪窗口并居中）
}

#pragma mark - Clip

/// 开始裁剪：按当前蒙层形状（矩形/圆形）裁剪裁剪窗口对应的图片区域，并跳转到结果页展示
- (void)beginClip {
    UIImage *image = self.imageScaleView.image;
    if (image == nil || CGRectIsEmpty(self.imageScaleView.cropRect)) {
        return;
    }
    CGRect pixelRect = [self.imageScaleView getClippingPixelRect];
    CJRectPathType pathType = self.imageScaleView.shapeType;
    UIImage *clipResultImage = [UIImage cj_clipImage:image
                                         inPixelRect:pixelRect
                                            pathType:pathType];
    
    TSMaskClipResultViewController *resultVC = [[TSMaskClipResultViewController alloc] init];
    resultVC.clipImage = clipResultImage;
    [self.navigationController pushViewController:resultVC animated:YES];
}

@end
