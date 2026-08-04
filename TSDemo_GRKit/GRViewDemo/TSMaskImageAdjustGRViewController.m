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
#import <CJGRKit/CQMaskImageAdjustGRView.h>

#import "UIImage+CJClipUtil.h"
#import "TSMaskClipResultViewController.h"

@interface TSMaskImageAdjustGRViewController () {
    
}
@property (nonatomic, strong) CQMaskImageAdjustGRView *imageScaleView;

@end

@implementation TSMaskImageAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    
    UIView *buttonsContainerView = [self buildButtonsContainerView];
    [self.view addSubview:buttonsContainerView];
    [buttonsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-10);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    CQMaskImageAdjustGRView *imageScaleView = [[CQMaskImageAdjustGRView alloc] initWithFrame:CGRectZero];
    imageScaleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageScaleView];
    [imageScaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(10);
        make.bottom.mas_equalTo(buttonsContainerView.mas_top).mas_offset(-10);
    }];
    self.imageScaleView = imageScaleView;
    imageScaleView.pinchMaxScale =  2;
    
    
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    imageScaleView.image = localImageRandom;
    [imageScaleView updateFrameByImage:localImageRandom];
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
        weakSelf.imageScaleView.image = image;
        [weakSelf.imageScaleView updateFrameByImage:image];
    }];
    
    // 蒙层形状预览
    CQTSRadioButtonsView *maskButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"矩形预览", @"圆形预览"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        [weakSelf.imageScaleView updateMaskWithRectPathType:(index == 0 ? CJRectPathTypeRectangle : CJRectPathTypeCircle)];
    }];
    
    // 框外蒙层透明度
    CQTSRadioButtonsView *opacityButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"框外隐藏", @"框外可见"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        weakSelf.imageScaleView.restMaskOpacity = (index == 0 ? 1.0 : 0.3); // 静止时框外蒙层透明度
        weakSelf.imageScaleView.maskLayer.opacity = weakSelf.imageScaleView.restMaskOpacity; // 立即生效
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

#pragma mark - Clip

/// 开始裁剪：按当前蒙层形状（矩形/圆形）裁剪，并跳转到结果页展示
- (void)beginClip {
    CJRectPathType pathType = self.imageScaleView.clearRectangleType;
    UIImage *clipResultImage = [UIImage cj_clipImage:self.imageScaleView.imageView.image
                                         inPixelRect:[self.imageScaleView getClippingPixelRect]
                                            pathType:pathType];
    
    TSMaskClipResultViewController *resultVC = [[TSMaskClipResultViewController alloc] init];
    resultVC.clipImage = clipResultImage;
    [self.navigationController pushViewController:resultVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
