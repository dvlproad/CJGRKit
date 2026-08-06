//
//  TSFeatureLookGRViewController.m
//  CJViewGRDemo
//
//  Created by dvlproad on 2026/08/07.
//

#import "TSFeatureLookGRViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>

// 图片查看器：只读缩放滚动+双击放大+单击/长按/下拉关闭
#import "TSImageScrollViewerViewController.h"

@interface TSFeatureLookGRViewController () {
    
}

@end

@implementation TSFeatureLookGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"查看", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 图片查看器
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"图片查看器：只读查看";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片查看器：缩放滚动+双击放大+单击/长按/下拉关闭";
            module.content = [@[
                @"只读查看大图（fit 居中），缩放后可滚动浏览",
                @"双击放大/还原，单击/长按回调、下拉关闭触发",
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSImageScrollViewerViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}

@end
