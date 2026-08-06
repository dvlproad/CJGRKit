//
//  TSViewGRExtensionHomeViewController.m
//  CJFoundationDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSViewGRExtensionHomeViewController.h"

//ViewDrag
#import "DragViewController.h"

// View Pandown
#import "ViewPandownViewController1.h"
#import "ViewPandownViewController2.h"

// UIView+CJGR
#import "TSGRExtensionViewController.h"
// UIView+CJKeepCoveredBounds
#import "TSGRKeepCoveredBoundsViewController.h"


@interface TSViewGRExtensionHomeViewController ()

@end

@implementation TSViewGRExtensionHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"UIView(FreeDrag+KeepBounds、Pandown、CJGR)", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *bundleName = @"TSDemo_GRKit";
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [frameworkBundle URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *resourceBundle = bundleURL ? [NSBundle bundleWithURL:bundleURL] : nil;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    //Drag
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJFreeDrag";
        {
            CQDMModuleModel *dragViewModule = [[CQDMModuleModel alloc] init];
            dragViewModule.title = @"任意视图：位置调整\nDrag And KeepBounds (视图的拖曳和吸附)";
            dragViewModule.content = [@[
                @"#import <CJGRKit/UIView+CJFreeDrag.h>",
                @"#import <CJGRKit/UIView+CJKeepInBounds.h>"
            ] componentsJoinedByString:@"\n"];
            dragViewModule.classEntry = [DragViewController class];
            dragViewModule.isCreateByXib = YES;
            //dragViewModule.xibBundle = resourceBundle;
            dragViewModule.xibBundleName = @"TSDemo_GRKit";
            [sectionDataModel.values addObject:dragViewModule];
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
    
    // UIView+CJGR
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJGR";
        {
            CQDMModuleModel *grModule = [[CQDMModuleModel alloc] init];
            grModule.title = @"任意视图：拖动/缩放/旋转+角按钮\n(独立能力，按需组合)";
            grModule.content = [@[
                @"#import <CJGRKit/UIView+CJGR.h>",
                @"[view cj_addPanGR];       //拖动",
                @"[view cj_addPinchGR];      //缩放",
                @"[view cj_addRotationGR];   //旋转",
                @"#import <CJGRKit/UIView+CJGRCorner.h>",
                @"[view cj_setCornerBorderWithColor:[UIColor blackColor]];",
                @"[view cj_addCornerDeleteButtonWithBlock:...];",
                @"[view cj_addCornerUpdateButtonWithBlock:...];",
                @"[view cj_addCornerMinimizeHandle];",
            ] componentsJoinedByString:@"\n"];
            grModule.classEntry = [TSGRExtensionViewController class];
            [sectionDataModel.values addObject:grModule];
        }
        {
            CQDMModuleModel *clipModule = [[CQDMModuleModel alloc] init];
            clipModule.title = @"任意视图：外方向约束\n(自由拖动+缩放，松手吸附回窗口)";
            clipModule.content = [@[
                @"#import <CJGRKit/UIView+CJGR.h>",
                @"#import <CJGRKit/UIView+CJKeepCoveredBounds.h>",
                @"[view cj_addPanGR];   //拖动",
                @"[view cj_addPinchGR];  //缩放",
                @"[view cj_setKeepCoveredRect:windowBounds];  //外方向约束",
            ] componentsJoinedByString:@"\n"];
            clipModule.classEntry = [TSGRKeepCoveredBoundsViewController class];
            [sectionDataModel.values addObject:clipModule];
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
