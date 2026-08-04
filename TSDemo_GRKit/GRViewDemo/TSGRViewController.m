//
//  TSGRViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSGRViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJGRKit/CJGRView.h>

@interface TSGRViewController () {
    
}
@property (nonatomic, strong) CJGRView *imageScaleView;

@end


@implementation TSGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CJGRView *imageScaleView = [[CJGRView alloc] initWithSubViewCreateBlock:^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage *image = [CQTSAssetSourceUtil localImageAtIndex:0 folderNames:@[@"jpg"]];
        imageView.image = image;
        
        return imageView;
        
    } panStateChangeBlock:^(UIGestureRecognizerState panGRState) {
        if(panGRState == UIGestureRecognizerStateBegan) {
            [CJUIKitToastUtil showMessage:@"拖动Pan开始"];
        } else if (panGRState == UIGestureRecognizerStateChanged) {
            [CJUIKitToastUtil showMessage:@"拖动Pan变化中"];
        } else if (panGRState == UIGestureRecognizerStateEnded) {
            [CJUIKitToastUtil showMessage:@"拖动Pan结束"];
        }
        
    } pinchStateChangeBlock:^(UIGestureRecognizerState pinchGRState, CGFloat pinchScale) {
        if(pinchGRState == UIGestureRecognizerStateBegan) {
            [CJUIKitToastUtil showMessage:@"捏合Pinch开始"];
        } else if (pinchGRState == UIGestureRecognizerStateChanged) {
            [CJUIKitToastUtil showMessage:@"捏合Pinch变化中"];
        } else if (pinchGRState == UIGestureRecognizerStateEnded) {
            [CJUIKitToastUtil showMessage:@"捏合Pinch结束"];
        }
    }];
    imageScaleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageScaleView];
    [imageScaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(100);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    self.imageScaleView = imageScaleView;
    
    [imageScaleView updateScaleShowViewOriginFrame:CGRectMake(10, 10, 100, 100)];
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
