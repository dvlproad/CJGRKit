//
//  TSMaskImageAdjustGRViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSMaskImageAdjustGRViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJGRKit/CQMaskImageAdjustGRView.h>

@interface TSMaskImageAdjustGRViewController () {
    
}
@property (nonatomic, strong) CQMaskImageAdjustGRView *imageScaleView;

@end

@implementation TSMaskImageAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    UIView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"竖直长图", @"水平宽图", @"随机图"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
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
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    __weak typeof(self) weakSelf2 = weakSelf;
    CQTSRadioButtonsView *maskButtonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"矩形", @"圆形"] alongAxis:MASAxisTypeHorizontal fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        [weakSelf2.imageScaleView updateMaskWithRectPathType:(index == 0 ? CJRectPathTypeRectangle : CJRectPathTypeCircle)];
    }];
    [self.view addSubview:maskButtonsView];
    [maskButtonsView didSelectItemAtIndex:0]; // 默认选中"矩形"
    [maskButtonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-20);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    CQMaskImageAdjustGRView *imageScaleView = [[CQMaskImageAdjustGRView alloc] initWithFrame:CGRectZero];
    imageScaleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageScaleView];
    [imageScaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(20);
        make.bottom.mas_equalTo(maskButtonsView.mas_top).mas_offset(-20);
    }];
    self.imageScaleView = imageScaleView;
    imageScaleView.pinchMaxScale =  2;
    
    
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    imageScaleView.image = localImageRandom;
    [imageScaleView updateFrameByImage:localImageRandom];
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
