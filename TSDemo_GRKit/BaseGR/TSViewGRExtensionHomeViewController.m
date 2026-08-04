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


@interface TSViewGRExtensionHomeViewController ()

@end

@implementation TSViewGRExtensionHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"UIView首页(Drag+Popup+Animate)", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *bundleName = @"TSDemo_GRKit";
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [frameworkBundle URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *resourceBundle = bundleURL ? [NSBundle bundleWithURL:bundleURL] : nil;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    //Drag
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"UIView+CJDragAction";
        {
            CQDMModuleModel *dragViewModule = [[CQDMModuleModel alloc] init];
            dragViewModule.title = @"任意视图：位置调整\nDrag And KeepBounds (视图的拖曳和吸附)";
            dragViewModule.content = [@[
                @"#import <CJGRKit/UIView+CJDragAction.h>",
                @"#import <CJGRKit/UIView+CJKeepBounds.h>"
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
        sectionDataModel.theme = @"UIView+CJPanAction";
        {
            CQDMModuleModel *panModule = [[CQDMModuleModel alloc] init];
            panModule.title = @"View Pandown (仿抖音评论下拉,对列表需自己包装container)";
            panModule.content = [@[
                @"UIView+CJPanAction 已封装进 View",
            ] componentsJoinedByString:@"\n"];
            panModule.classEntry = [ViewPandownViewController1 class];
            [sectionDataModel.values addObject:panModule];
        }
        {
            CQDMModuleModel *panModule = [[CQDMModuleModel alloc] init];
            panModule.title = @"View Pandown (仿抖音评论下拉,对所有都不需自己包装container)";
            panModule.content = [@[
                @"UIView+CJPanAction 未封装进 View",
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
