//
//  DragViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "DragViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CQDemoResource/UIImage+CQDemoResource.h>

#import <CJGRKit/UIView+CJDragAction.h>
#import <CJGRKit/UIView+CJKeepBounds.h>

@interface DragViewController ()

@property (nonatomic, strong) IBOutlet UIView *redView;
@property (nonatomic, strong) IBOutlet UIButton *orangeButton;

@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"可拖曳的View", nil);
    
    self.redView.cjDragEnable = YES;
    [self.redView setCjDragEndBlock:^(UIView *view) {
        [view cjKeepBounds];
        [CJUIKitToastUtil showMessage:@"拖动结束"];
    }];
    
    
    [self.orangeButton setTitle:@"可拖曳" forState:UIControlStateNormal];
    [self.orangeButton addTarget:self action:@selector(orangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.orangeButton.cjDragEnable = YES;
    [self.orangeButton setCjDragBeginBlock:^(UIView *view) {
        NSLog(@"开始拖曳橙色视图");
        [CJUIKitToastUtil showMessage:@"开始拖曳橙色视图"];
    }];
    [self.orangeButton setCjDragEndBlock:^(UIView *view) {
        NSLog(@"结束拖曳橙色视图");
        [view cjKeepBounds];
        [CJUIKitToastUtil showMessage:@"结束拖曳橙色视图"];
    }];
    
    //UIImage *bgImage = [CQTSAssetSourceUtil localImageAtIndex:0 folderNames:@[@"jpg"]];
    UIImage *bgImage = [UIImage cqresource_imageNamed:@"cqts_jpg_bgSky.jpg"];
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoButton setFrame:CGRectMake(0, 0 , 70, 70)];
    logoButton.center = self.view.center;
    logoButton.layer.cornerRadius = 14;
    [logoButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [logoButton addTarget:self action:@selector(closeLogoButton:) forControlEvents:UIControlEventTouchUpInside];
    logoButton.cjDragEnable = YES;
    [logoButton setCjDragEndBlock:^(UIView *view) {
        [view cjKeepBoundsWithBoundEdgeInsets:UIEdgeInsetsMake(64, 20, 0, 20)
                isKeepBoundsXYWhenBeyondBound:YES
             isKeepBoundsXWhenContaintInBound:YES
             isKeepBoundsYWhenContaintInBound:NO];
        [CJUIKitToastUtil showMessage:@"拖动结束"];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:logoButton]; //添加到window上了
}

- (void)closeLogoButton:(UIButton *)logoButton {
    [logoButton removeFromSuperview];
}

- (IBAction)orangeButtonAction:(UIButton *)button {
    NSLog(@"绿色view被点击了");
    button.cjDragEnable = !button.cjDragEnable;
    if (button.cjDragEnable) {
        [button setTitle:@"可拖曳" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"不可拖曳" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
