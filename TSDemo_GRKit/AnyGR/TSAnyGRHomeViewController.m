//
//  TSAnyGRHomeViewController.m
//  CJFoundationDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSAnyGRHomeViewController.h"

// UIView+CJAnyGR
#import "TSAnyGRViewController.h"
// UIView+CJKeepBounds
#import "TSKeepInBoundsViewController.h"
#import "TSKeepCoveredBoundsViewController.h"

// View Pandown
#import "ViewPandownViewController1.h"
#import "ViewPandownViewController2.h"


@interface TSAnyGRHomeViewController ()

@end

@implementation TSAnyGRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"UIView(AnyGR、CornerGR、KeepBounds、PanDown)", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *bundleName = @"TSDemo_GRKit";
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [frameworkBundle URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *resourceBundle = bundleURL ? [NSBundle bundleWithURL:bundleURL] : nil;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // UIView+CJAnyGR
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJAnyGR(+CornerGR)";
        {
            CQDMModuleModel *grModule = [[CQDMModuleModel alloc] init];
            grModule.title = @"任意视图：拖动/缩放/旋转+角按钮\n(独立能力，按需组合)";
            grModule.content = [@[
                @"#import <CJGRKit/UIView+CJAnyGR.h>",
                @"[view cj_addPanGR];       //拖动",
                @"[view cj_addPinchGR];      //缩放",
                @"[view cj_addRotationGR];   //旋转",
                @"#import <CJGRKit/UIView+CJCornerGR.h>",
                @"[view cj_setCornerBorderWithColor:[UIColor blackColor]];",
                @"[view cj_addCornerDeleteButtonWithBlock:...];",
                @"[view cj_addCornerUpdateButtonWithBlock:...];",
                @"[view cj_addCornerMinimizeHandle];",
            ] componentsJoinedByString:@"\n"];
            grModule.classEntry = [TSAnyGRViewController class];
            [sectionDataModel.values addObject:grModule];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // UIView+CJKeepBounds
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJKeepBounds";
        {
            CQDMModuleModel *keepInModule = [[CQDMModuleModel alloc] init];
            keepInModule.title = @"内方向约束：自由拖动，松手吸附回自身(单选三档策略)\nKeepInBounds";
            keepInModule.content = [@[
                @"#import <CJGRKit/UIView+CJAnyGR.h>",
                @"#import <CJGRKit/UIView+CJKeepInBounds.h>",
                @"[view cj_addPanGR];   //拖动",
                @"[view cjKeepBoundsWithBoundEdgeInsets:...];  //松手按档位吸附",
                @"//三档：①出界+界内都吸附 ②仅出界吸附 ③无约束对照",
            ] componentsJoinedByString:@"\n"];
            keepInModule.classEntry = [TSKeepInBoundsViewController class];
            [sectionDataModel.values addObject:keepInModule];
        }
        {
            CQDMModuleModel *clipModule = [[CQDMModuleModel alloc] init];
            clipModule.title = @"外方向约束：自由拖动+缩放，松手吸附回窗口(单选三档覆盖)\nKeepCoveredBounds";
            clipModule.content = [@[
                @"#import <CJGRKit/UIView+CJAnyGR.h>",
                @"#import <CJGRKit/UIView+CJKeepCoveredBounds.h>",
                @"[view cj_addPanGR];   //拖动",
                @"[view cj_addPinchGR];  //缩放",
                @"[view cj_setKeepCoveredRect:windowBounds];  //外方向约束",
                @"//三档覆盖力度：①1.5x ②1.2x ③0.9x(不足自动放大)",
            ] componentsJoinedByString:@"\n"];
            clipModule.classEntry = [TSKeepCoveredBoundsViewController class];
            [sectionDataModel.values addObject:clipModule];
        }
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // View Pandown
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJPanDown";
        {
            CQDMModuleModel *panModule = [[CQDMModuleModel alloc] init];
            panModule.title = @"View Pandown (仿抖音评论下拉,对列表需自己包装container)";
            panModule.content = [@[
                @"UIView+CJPanDown 已封装进 View",
            ] componentsJoinedByString:@"\n"];
            panModule.classEntry = [ViewPandownViewController1 class];
            [sectionDataModel.values addObject:panModule];
        }
        {
            CQDMModuleModel *panModule = [[CQDMModuleModel alloc] init];
            panModule.title = @"View Pandown (仿抖音评论下拉,对所有都不需自己包装container)";
            panModule.content = [@[
                @"UIView+CJPanDown 未封装进 View",
            ] componentsJoinedByString:@"\n"];
            panModule.classEntry = [ViewPandownViewController2 class];
            [sectionDataModel.values addObject:panModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
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
