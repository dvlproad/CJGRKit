//
//  TSImageNormalAdjustGRScrollViewController.m
//  TSDemo_ImageFilter
//
//  Created by qian on 2021/3/5.
//

#import "TSImageNormalAdjustGRScrollViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSContainerViewFactory.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJGRKit/CJImageGRScrollView.h>

@interface TSImageNormalAdjustGRScrollViewController () {
    
}
@property (nonatomic, strong) CJImageGRScrollView *imageScaleView;

@end

@implementation TSImageNormalAdjustGRScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"使用场景1：一个可进行拖动和缩放的图片视图本身", nil);
    
    UIView *buttonsView = [CQTSContainerViewFactory twoButtonsViewAlongAxis:MASAxisTypeVertical title1:@"竖直长图" actionBlock1:^(UIButton * _Nonnull bButton) {
        UIImage *image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_vertical_1.jpg"];
        self.imageScaleView.image = image;
        
    } title2:@"水平宽图" actionBlock2:^(UIButton * _Nonnull bButton) {
        UIImage *image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_horizontal_1.jpg"];
        self.imageScaleView.image = image;
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(50*2+10*1);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    CJImageGRScrollView *imageScaleView = [[CJImageGRScrollView alloc] initWithContentMode:UIViewContentModeScaleAspectFill];
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
    
    
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    imageScaleView.image = localImageRandom;
    
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
