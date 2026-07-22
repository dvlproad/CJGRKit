//
//  TSImageSourceUtil.m
//  CQDemoResource
//
//  Created by ciyouzen on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "TSImageSourceUtil.h"
#import <CQDemoResource/CQTSAssetSourceUtil.h>

@implementation TSImageSourceUtil

+ (UIImage *)longVertical01 {
    UIImage *image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_vertical_1.jpg"];
    return image;
}

+ (UIImage *)longHorizontal01 {
    UIImage *image = [UIImage cqresource_imageNamed:@"cqts_jpg_long_horizontal_1.jpg"];
    return image;
}

+ (UIImage *)localImageRandom {
    NSInteger trySelIndex = random();
    NSArray<NSString *> *folderNames = @[@"png", @"jpg"];
    UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
    return localImageRandom;
}

@end
