//
//  CQTSBottomBlankView.h
//  CQDemoKit
//
//  Created by ciyouzen on 2026/08/04.
//

#import <UIKit/UIKit.h>
#import "CQTSBlankViewProtocol.h"

@class CQTSBlankPresenter;

NS_ASSUME_NONNULL_BEGIN

@interface CQTSBottomBlankView : UIView <CQTSBlankViewProtocol>

@property (nonatomic, strong, readonly) UIView *popupView;          /**< 弹出的内容视图 */
@property (nonatomic, assign, readonly) CGFloat popupViewHeight;    /**< 弹出的内容视图的高度 */

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】（内容视图左右铺满容器）
 *
 *  @param popupView            弹出视图的内容视图
 *  @param popupViewHeight      弹出视图的高度
 */
- (instancetype)initWithPopupView:(UIView *)popupView
                  popupViewHeight:(CGFloat)popupViewHeight
                 tapBlankComplete:(void(^ _Nullable)(CQTSBottomBlankView *bBlankView))tapBlankComplete NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Get Method
/// 通过 popupView 获取到其所在的 popupView 容器，常用于 popupView 中的点击需要让容器隐藏等动作
+ (nullable CQTSBottomBlankView *)blankViewFromPopupView:(UIView *)popupView;

@end

NS_ASSUME_NONNULL_END
