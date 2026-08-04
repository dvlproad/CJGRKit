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
#import <CJGRKit/CJImageNormalAdjustGRView.h>

@interface TSImageNormalAdjustGRViewController () {
    
}
@property (nonatomic, strong) CJImageNormalAdjustGRView *imageScaleView;

@end

@implementation TSImageNormalAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"使用场景1：一个可进行拖动和缩放的图片视图本身", nil);
    
    __weak typeof(self) weakSelf = self;
    UIView *buttonsView = [[CQTSRadioButtonsView alloc] initWithTitles:@[@"竖直长图", @"水平宽图"] alongAxis:MASAxisTypeVertical fixedSpacing:10 didSelectItemAtIndexHandle:^(NSInteger index) {
        UIImage *image = index == 0 ? [TSImageSourceUtil longVertical01] : [TSImageSourceUtil longHorizontal01];
        weakSelf.imageScaleView.image = image;
        [weakSelf.imageScaleView updateFrameByImage:image];
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(44*2+10*1);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    CJImageNormalAdjustGRView *imageScaleView = [[CJImageNormalAdjustGRView alloc] initWithContentMode:UIViewContentModeScaleAspectFill];
    imageScaleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageScaleView];
    [imageScaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(20);
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-20);
    }];
    self.imageScaleView = imageScaleView;
    imageScaleView.pinchMaxScale =  2;
    
    UIImage *localImageRandom = [TSImageSourceUtil localImageRandom];
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
