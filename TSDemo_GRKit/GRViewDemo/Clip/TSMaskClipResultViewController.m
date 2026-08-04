//
//  TSMaskClipResultViewController.m
//  CJViewGRDemo
//
//  Created by qian on 2021/3/5.
//

#import "TSMaskClipResultViewController.h"
#import <Masonry/Masonry.h>

@implementation TSMaskClipResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"裁剪结果", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.clipImage;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

@end
