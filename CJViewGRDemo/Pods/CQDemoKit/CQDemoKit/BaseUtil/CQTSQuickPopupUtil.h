//
//  CQTSQuickPopupUtil.h
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//
//  此为 Demo 所以不进行 CQTSQuickPopupUtil 的封装，而是用原始的方式来操作，使得更容易理解整个弹出的逻辑

#import <UIKit/UIKit.h>

#import "CQTSBottomBlankView.h"
#import "CQTSCenterBlankView.h"

#import "CQTSBlankPresenter.h"

/*
// 1.创建 blankPresenter
CQTSBlankPresenter *blankPresenter = [[CQTSBlankPresenter alloc] init];

// 2.创建 blankPresenter 要弹出的 blankView (bottom)
CQTSBottomBlankView *blankView = [[CQTSBottomBlankView alloc] initWithPopupView:popupView popupViewHeight:200 tapBlankComplete:^(CQTSBottomBlankView * _Nonnull bBlankView) {
    [blankPresenter hideBlankView:bBlankView];
}];
// 2.创建 blankPresenter 要弹出的 blankView (center)
CQTSCenterBlankView *blankView = [[CQTSCenterBlankView alloc] initWithPopupView:contentView
                                                                  popupViewSize:popupViewSize
                                                              popupCenterOffset:CGPointZero
                                                               tapBlankComplete:tapBlankComplete];
// 3.使用 blankPresenter 弹出 blankView
[blankPresenter showBlankView:blankView inView:nil complete:nil];
*/
