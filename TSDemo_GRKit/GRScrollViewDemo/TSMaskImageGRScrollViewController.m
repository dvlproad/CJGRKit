//
//  TSMaskImageGRScrollViewController.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/3.
//

#import "TSMaskImageGRScrollViewController.h"
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJGRKit/CJImageGRScrollView.h>
#import <CJGRKit/CQMaskCenterView.h>

#import "TSImageSourceUtil.h"

@interface TSMaskImageGRScrollViewController () {
    
}
@property (nonatomic, strong) CQMaskCenterView *maskView;

@end

@implementation TSMaskImageGRScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
//    [self.maskView showOccludedView:YES];
}

- (void)setupViews {
    CQMaskCenterView *maskView = [[CQMaskCenterView alloc] init];
    maskView.backgroundColor = UIColor.greenColor;
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(100);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    self.maskView = maskView;
    
    
    UIImage *localImageRandom = [TSImageSourceUtil localImageRandom];
    self.maskView.image = localImageRandom;
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
