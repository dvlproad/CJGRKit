//
//  TSAdjustGRViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSAdjustGRViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CQTSContainerViewFactory.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJGRKit/CJAdjustGRView.h>
#import <CJGRKit/CGRectCJSubHelper.h>   // 用于裁剪区域及拖动限制区域的获取

@interface TSAdjustGRViewController () {
    
}
@property (nonatomic, strong) CJAdjustGRView *grAdjustView;
@property (nonatomic, assign) NSInteger useType;

@end

@implementation TSAdjustGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *buttonsView = [CQTSContainerViewFactory twoButtonsViewAlongAxis:MASAxisTypeVertical title1:@"使用场景1：拖动图片进行裁剪" actionBlock1:^(UIButton * _Nonnull bButton) {
        [self useType1];
        
    } title2:@"使用场景2：一个可进行拖动和缩放的图片视图本身" actionBlock2:^(UIButton * _Nonnull bButton) {
        [self useType2];
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-20);
        make.height.mas_equalTo(50*2+10*1);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    CJAdjustGRView *grAdjustView = [[CJAdjustGRView alloc] initWithSubViewCreateBlock:^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES; // 超出部分截取
        imageView.backgroundColor = [UIColor magentaColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_vertical_1.jpg"];
        imageView.image = image;
        return imageView;
        
    } clippingViewCreateBlock:^UIView * _Nonnull{
        UIView *clippingRegionView = [[UIView alloc] init];
        clippingRegionView.backgroundColor = [UIColor redColor];
        clippingRegionView.alpha = 0.5;
        return clippingRegionView;
    }];
    grAdjustView.pinchMaxScale = 3;
    grAdjustView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:grAdjustView];
    [grAdjustView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(20);
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-20);
    }];
    self.grAdjustView = grAdjustView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 使用场景1：拖动图片进行裁剪
//        [self useType1];
        
//        // 使用场景2：一个可进行拖动和缩放的图片视图本身
//        [self useType2];
    });
}

// 使用场景1：拖动图片进行裁剪
- (void)useType1 {
    CGRect grAdjustViewFrame = self.grAdjustView.frame;
    
    // 使用场景1：拖动图片进行裁剪
    CGFloat clippingFrameRatio = 1/1.0; // 裁剪框的比例
    CGRect clippingFrame = [CGRectCJSubHelper getMaxSubFrameWithRatio:clippingFrameRatio inCageFrame:grAdjustViewFrame subFramePositon:YES];
    self.grAdjustView.clippingFrame = clippingFrame; // 裁剪框的frame（拖动时候用来限制范围，缩放时候用来限制大小）

    UIImage *image = ((UIImageView *)self.grAdjustView.scaleShowView).image;
    CGFloat minShowFrameRatio = image.size.width/image.size.height; // 显示视图的比例
    CGRect minShowFrame = [CGRectCJSubHelper getMinSubFrameWithRatio:minShowFrameRatio
                                                               minWidth:CGRectGetWidth(clippingFrame)
                                                              minHeight:CGRectGetHeight(clippingFrame)
                                                            inCageFrame:grAdjustViewFrame
                                                        subFramePositon:YES];
    [self.grAdjustView updateScaleShowViewOriginFrame:minShowFrame]; // 内容显示的frame
}


// 使用场景2：一个可进行拖动和缩放的图片视图本身
- (void)useType2 {
    CGRect grAdjustViewFrame = self.grAdjustView.frame;
    
    CGRect showViewOriginFrame = CGRectMake(0, 0, CGRectGetWidth(grAdjustViewFrame), CGRectGetHeight(grAdjustViewFrame));
    self.grAdjustView.clippingFrame = showViewOriginFrame; // 裁剪框的frame（拖动时候用来限制范围，缩放时候用来限制大小）
//    [self.grAdjustView updateScaleShowViewOriginFrame:showViewOriginFrame]; // 内容显示的frame
    
    
    UIImage *image = ((UIImageView *)self.grAdjustView.scaleShowView).image;
    CGFloat minShowFrameRatio = image.size.width/image.size.height; // 显示视图的比例
    CGRect minShowFrame = [CGRectCJSubHelper getMinSubFrameWithRatio:minShowFrameRatio
                                                               minWidth:CGRectGetWidth(showViewOriginFrame)
                                                              minHeight:CGRectGetHeight(showViewOriginFrame)
                                                            inCageFrame:grAdjustViewFrame
                                                        subFramePositon:YES];
    [self.grAdjustView updateScaleShowViewOriginFrame:minShowFrame]; // 内容显示的frame
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
