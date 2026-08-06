//
//  TSImageScrollViewerViewController.m
//  CJViewGRDemo
//
//  Created by dvlproad on 2026/08/07.
//

#import "TSImageScrollViewerViewController.h"
#import <Masonry/Masonry.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CQTSRadioButtonsView.h>
#import <CQDemoResource/CQTSAssetSourceUtil.h>
#import <CJFeatureGRView/CJImageScrollViewer.h>

@interface TSImageScrollViewerViewController ()

@property (nonatomic, strong) CJImageScrollViewer *viewerView;   // 单图查看器（只读缩放滚动 + 双击放大 + 单击/长按/下拉关闭）

@end

@implementation TSImageScrollViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"图片查看器：CJImageScrollViewer", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    
    // 选图按钮（复用 demo 资源）
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
        weakSelf.viewerView.image = image;
    }];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-10);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    // 单图查看器
    CJImageScrollViewer *viewerView = [[CJImageScrollViewer alloc] init];
    viewerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewerView];
    [viewerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(10);
        make.bottom.mas_equalTo(buttonsView.mas_top).mas_offset(-10);
    }];
    self.viewerView = viewerView;
    
    viewerView.maxScale = 3.0;
    viewerView.singleTapBlock = ^{
        [CJUIKitToastUtil showMessage:@"单击"];
    };
    viewerView.longPressBlock = ^{
        [CJUIKitToastUtil showMessage:@"长按"];
    };
    viewerView.dragDownCloseBlock = ^{
        [CJUIKitToastUtil showMessage:@"下拉关闭触发"];
    };
    
    // 初始图（组件内部 layoutSubviews 首次自动 fit 布局，无需等布局完成）
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    viewerView.image = localImageRandom;
}

@end
