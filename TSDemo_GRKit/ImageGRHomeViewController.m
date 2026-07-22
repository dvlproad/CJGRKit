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
#import "TSImageNormalAdjustGRScrollViewController.h"





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
            module.title = @"任意视图：缩放(CJGRView)";
            module.classEntry = [TSGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"任意视图：位置调整";
            module.content = [@[
                @"#import <CJBaseUIKit/UIView+CJDragAction.h>",
                @"#import <CJGRKit/UIView+CJKeepBounds.h>"
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [DragViewController class];
            module.isCreateByXib = YES;
            module.xibBundleName = @"TSDemo_GRKit";
            
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
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(裁剪)：缩放+位置调整(CJImageClipAdjustGRView)";
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
            module.title = @"图片视图(裁剪)：缩放+位置调整+蒙版(CJMaskImageAdjustGRView)";
            module.content = [@[
                @"继承于 CJImageClipAdjustGRView",
                @"有蒙版"
            ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSMaskImageAdjustGRViewController class];
            [sectionDataModel.values addObject:module];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    // 缩放+位置调整：使用CJGRScrollView
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"缩放+位置调整：使用CJGRScrollView";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"图片视图(普通)：缩放+位置调整(CJImageGRScrollView 类似 CJImageNormalAdjustGRView)";
            module.content = [@[
                @"使用场景1：一个可进行拖动和缩放的图片视图本身",
                @"图片普通调整（缩放、拖动）视图，没有裁剪框。场景：如图片拼接里的位置、大小调整。"
                ] componentsJoinedByString:@"\n"];
            module.classEntry = [TSImageNormalAdjustGRScrollViewController class];
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
