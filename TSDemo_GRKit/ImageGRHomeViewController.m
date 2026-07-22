//
//  ImageGRHomeViewController.m
//  TSImageFilterDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ImageGRHomeViewController.h"

// 图片视图：缩放+位置调整+蒙版：使用CJGRView
#import "TSGRViewController.h"
#import "DragViewController.h"
#import "TSAdjustGRViewController.h"
#import "TSImageClipAdjustGRViewController.h"
#import "TSImageNormalAdjustGRViewController.h"
#import "TSMaskImageAdjustGRViewController.h"


// 图片视图：缩放+位置调整+蒙版：使用CJGRScrollView
#import "TSImageNormalAdjustGRViewController2.h"
#import "TSMaskImageGRScrollViewController.h"





@interface ImageGRHomeViewController () {
    
}

@end

@implementation ImageGRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"视图：缩放+位置调整+蒙版", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
   
    // 缩放+位置调整+蒙版：使用CJGRView
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整+蒙版：使用CJGRView";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：缩放";
            module.classEntry = [TSGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：位置调整";
            module.classEntry = [DragViewController class];
            module.isCreateByXib = YES;
            module.xibBundleName = @"TSDemo_ImageFilter";
            
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：缩放+位置调整";
            module.classEntry = [TSAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图：缩放+位置调整";
            module.content = @"使用场景1：拖动图片进行裁剪";
            module.classEntry = [TSImageClipAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图：缩放+位置调整";
            module.content = @"使用场景2：一个可进行拖动和缩放的图片视图本身";
            module.classEntry = [TSImageNormalAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图：缩放+位置调整+蒙版";
            module.classEntry = [TSMaskImageAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    // 图片缩放与位置调整+添加蒙版
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整+蒙版：使用CJGRScrollView";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图：缩放+位置调整";
            module.content = @"使用场景2：一个可进行拖动和缩放的图片视图本身";
            module.classEntry = [TSImageNormalAdjustGRViewController2 class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片缩放与位置调整+添加蒙版(BUG蒙层跑底部去了)";
            module.classEntry = [TSMaskImageGRScrollViewController class];
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
