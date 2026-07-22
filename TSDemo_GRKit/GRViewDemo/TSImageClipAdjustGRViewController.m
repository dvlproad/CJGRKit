//
//  TSImageClipAdjustGRViewController.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//

#import "TSImageClipAdjustGRViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSContainerViewFactory.h>
#import "TSImageSourceUtil.h"
#import <CJGRKit/CJImageClipAdjustGRView.h>

@interface TSImageClipAdjustGRViewController () {
    
}
@property (nonatomic, strong) CJImageClipAdjustGRView *imageScaleView;

@end

@implementation TSImageClipAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"使用场景1：拖动图片进行裁剪", nil);
    
    UIView *buttonsView = [CQTSContainerViewFactory twoButtonsViewAlongAxis:MASAxisTypeVertical title1:@"竖直长图" actionBlock1:^(UIButton * _Nonnull bButton) {
        UIImage *image = [TSImageSourceUtil longVertical01];
        [self.imageScaleView imageView].image = image;
        [self.imageScaleView updateFrameByImage:image];
        
    } title2:@"水平宽图" actionBlock2:^(UIButton * _Nonnull bButton) {
        UIImage *image = [TSImageSourceUtil longHorizontal01];
        [self.imageScaleView imageView].image = image;
        [self.imageScaleView updateFrameByImage:image];
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(50*2+10*1);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    CJImageClipAdjustGRView *imageScaleView = [[CJImageClipAdjustGRView alloc] initWithClippingViewCreateBlock:^UIView * _Nonnull{
        UIView *clippingRegionView = [[UIView alloc] init];
        clippingRegionView.backgroundColor = [UIColor redColor];
        clippingRegionView.alpha = 0.5;
        return clippingRegionView;
    }];
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
    [imageScaleView imageView].image = localImageRandom;
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
