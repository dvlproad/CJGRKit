//
//  TSFeatureEditGRViewController.m
//  TSImageFilterDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSFeatureEditGRViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>

// 图片视图：缩放+位置调整+蒙版：使用CJGRView（新模型：内容第一公民+约束叠加）
#import "TSImageNormalAdjustGRViewController.h"
#import "TSMaskImageAdjustGRViewController.h"



@interface TSFeatureEditGRViewController () {
    
}

@end

@implementation TSFeatureEditGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"编辑裁剪", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 缩放+位置调整+蒙版：使用CJGRView（新模型：内容第一公民 + 约束叠加）
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整+蒙版：使用CJGRView（新模型：内容第一公民+约束叠加）";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(普通)：缩放+位置调整(内容+KeepCoveredBounds)";
            module.content = [@[
                @"场景1：图片视图本身（内容覆盖编辑区，KeepCovered 约束手势结束吸附）",
                @"场景2：纯手势无约束（内容可自由拖动/缩放）",
                @"对齐旧 CJImageNormalAdjustGRView（clippingFrame=全视图）",
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSImageNormalAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(图片裁剪)：缩放+位置调整+蒙版(内容+KeepCoveredBounds+蒙层)";
            module.content = [@[
                @"1:1 裁剪窗口约束：内容覆盖窗口、手势结束吸附",
                @"蒙层：矩形/圆形镂空预览、框外蒙层透明度、拖动显示被遮挡区域",
                @"对齐旧 CJMaskImageAdjustGRView/CQMaskImageAdjustGRView",
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
