//
//  TSGRScrollViewHomeViewController.m
//  TSImageFilterDemo
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSGRScrollViewHomeViewController.h"

// 图片视图：缩放+位置调整+蒙版：使用CJGRScrollView
#import "TSImageNormalAdjustGRScrollViewController.h"


@interface TSGRScrollViewHomeViewController () {
    
}

@end

@implementation TSGRScrollViewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"视图：缩放+位置调整+蒙版", nil);

    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
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
