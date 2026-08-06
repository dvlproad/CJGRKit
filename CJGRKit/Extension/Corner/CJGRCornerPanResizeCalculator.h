//
//  CJGRCornerPanResizeCalculator.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：右下角缩放/旋转操作柄的 pan 换算器（纯计算，不参与手势识别和 transform 应用）。
//  把「手指位移」换算成「缩放倍率 + 旋转弧度」，即“角点绕中心运动”模型：
//   - 缩放 = 当前向量长度 ÷ 起始向量长度 × 起始缩放
//   - 旋转 = 当前向量角度 − 起始向量角度 + 起始旋转

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 一次拖动的结果
typedef struct CJGRCornerPanResizeResult {
    CGFloat scale;      /**< 换算得到的缩放倍率 */
    CGFloat rotation;   /**< 换算得到的旋转弧度 */
} CJGRCornerPanResizeResult;

/**
 *  右下角操作柄的缩放/旋转换算器（配合 pan 使用）。
 *  用法：panBegan... 对应 UIGestureRecognizerStateBegan 记录起始状态，
 *  panChangedWithTranslation: 对应 UIGestureRecognizerStateChanged 用位移更新，
 *  一次拖动结束后无需额外调用，下次 panBegan 会自动覆盖旧快照。
 */
@interface CJGRCornerPanResizeCalculator : NSObject

/**
 *  记录一次拖动的起始状态（对应 pan 的 UIGestureRecognizerStateBegan，只调一次）。
 *
 *  @param cornerVector  “中心 → 右下角”向量（未变换，即宽高的一半）
 *  @param startScale    拖动开始时的缩放倍率
 *  @param startRotation 拖动开始时的旋转弧度
 */
- (void)panBeganWithCornerVector:(CGPoint)cornerVector
                      startScale:(CGFloat)startScale
                   startRotation:(CGFloat)startRotation;

/**
 *  用当前手指位移更新换算结果（对应 pan 的 UIGestureRecognizerStateChanged，拖动中持续调用）。
 *
 *  @param translation 手指位移，坐标系与 cornerVector 在屏幕上的投影一致
 *
 *  @return 换算得到的缩放倍率与旋转弧度
 */
- (CJGRCornerPanResizeResult)panChangedWithTranslation:(CGPoint)translation;

@end

NS_ASSUME_NONNULL_END
