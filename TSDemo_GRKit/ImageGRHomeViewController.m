//
//  ImageGRHomeViewController.m
//  TSImageFilterDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ImageGRHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>

// 图片视图：缩放+位置调整+蒙版：使用CJGRView
#import "TSGRViewController.h"
#import "TSAdjustGRViewController.h"
#import "TSImageClipAdjustGRViewController.h"
#import "TSImageNormalAdjustGRViewController.h"
#import "TSMaskImageAdjustGRViewController.h"


// 图片视图：缩放+位置调整+蒙版：使用CJGRScrollView
#import "TSImageNormalAdjustGRScrollViewController.h"





@interface ImageGRHomeViewController () {
    
}

@end

@implementation ImageGRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"CJGRView视图：缩放+位置调整+蒙版", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
   
    // 缩放+位置调整+蒙版：使用CJGRView
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整+蒙版：使用CJGRView";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：缩放(CJGRView)";
            module.classEntry = [TSGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：缩放+位置调整(CJAdjustGRView)";
            module.content = [@[
                @"继承于 CJGRView",
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    // CJImageNormalAdjustGRView
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整+蒙版：使用CJGRView";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(普通)：缩放+位置调整(CJImageNormalAdjustGRView)";
            module.content = [@[
                @"继承于 CJAdjustGRView : CJGRView",
                @"使用场景1：一个可进行拖动和缩放的图片视图本身",
                @"图片普通调整（缩放、拖动）视图，没有裁剪框。场景：如图片拼接里的位置、大小调整。"
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSImageNormalAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    // CJImageClipAdjustGRView CJMaskImageAdjustGRView
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"图片裁剪：拖动图片裁剪（蒙层固定）";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(图片裁剪：拖动图片裁剪（蒙层固定）)：缩放+位置调整(CJImageClipAdjustGRView)";
            module.content = [@[
                @"继承于 CJAdjustGRView : CJGRView",
                @"使用场景2：拖动图片进行裁剪",
                @"图片裁剪调整（缩放、拖动）视图，有裁剪框。场景：如图片裁剪框里的位置、大小调整。"
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSImageClipAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(图片裁剪：拖动图片裁剪（蒙层固定）)：缩放+位置调整+蒙版(CJMaskImageAdjustGRView)";
            module.content = [@[
                @"继承于 CJImageClipAdjustGRView",
                @"有蒙版"
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSMaskImageAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 其他裁剪
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"图片裁剪：其他裁剪";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"画框裁剪（图定框动）";
            module.content = [@[
                @"截图选区域",
                @"截取图片中某块区域（去边缘杂物、截局部）",
                @"临时示例： TSImageFilterDemo"
                @"见《图片裁剪的交互方式与选型.md》",
            ] componentsJoinedByString:@"\n"];
            module.actionBlock = ^{
                [CJUIKitToastUtil showMessage:@"见《图片裁剪的交互方式与选型.md》"];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"可调框裁剪";
            module.content = [@[
                @"相册/图片编辑（自由构图，比例可选）",
                @"见《图片裁剪的交互方式与选型.md》",
            ] componentsJoinedByString:@"\n"];
            module.actionBlock = ^{
                [CJUIKitToastUtil showMessage:@"见《图片裁剪的交互方式与选型.md》"];
            };
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
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
