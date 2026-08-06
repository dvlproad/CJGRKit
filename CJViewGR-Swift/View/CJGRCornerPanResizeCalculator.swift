//
//  CJGRCornerPanResizeCalculator.swift
//  CJViewGR-Swift
//
//  Created by ciyouzen on 2026/08/06.
//  Copyright © 2026年 dvlproad. All rights reserved.
//
//  说明：右下角缩放/旋转操作柄的 pan 换算器（纯计算，不参与手势识别和 transform 应用）。
//  把「手指位移」换算成「缩放倍率 + 旋转弧度」，即“角点绕中心运动”模型：
//   - 缩放 = 当前向量长度 ÷ 起始向量长度 × 起始缩放
//   - 旋转 = 当前向量角度 − 起始向量角度 + 起始旋转
//
//  与 OC 版 CJGRCornerPanResizeCalculator 公式完全一致，方法签名也与 OC 方法在 Swift
//  中的映射一致，便于未来直接切换为复用 OC 实现。

import CoreGraphics

/// 一次拖动的结果
public struct CJGRCornerPanResizeResult {
    /// 换算得到的缩放倍率（真实倍数，非相对）
    public var scale: CGFloat
    /// 换算得到的旋转弧度
    public var rotation: CGFloat

    public init(scale: CGFloat, rotation: CGFloat) {
        self.scale = scale
        self.rotation = rotation
    }
}

/// 右下角操作柄的缩放/旋转换算器（配合 pan 使用）。
/// 用法：panBegan(withCornerVector:startScale:startRotation:) 对应拖动开始记录起始状态，
/// panChanged(withTranslation:) 对应拖动中持续更新，一次拖动结束后无需额外调用，
/// 下次 panBegan 会自动覆盖旧快照。
public final class CJGRCornerPanResizeCalculator {
    /// 拖动开始时的缩放（真实倍数）
    public private(set) var startScale: CGFloat = 1
    /// 拖动开始时的旋转（弧度）
    public private(set) var startRotation: CGFloat = 0

    private var startVector: CGSize = .zero    // 起始“中心→右下角”向量（屏幕坐标）
    private var startLength: CGFloat = 0       // 起始向量长度

    public init() {}

    /// 记录一次拖动的起始状态（对应拖动开始，只调一次）。
    ///
    /// - Parameters:
    ///   - cornerVector: “中心 → 右下角”向量（未变换，即宽高的一半）
    ///   - startScale: 拖动开始时的缩放倍率（真实倍数）
    ///   - startRotation: 拖动开始时的旋转弧度
    public func panBegan(withCornerVector cornerVector: CGSize,
                         startScale: CGFloat,
                         startRotation: CGFloat) {
        self.startScale = startScale
        self.startRotation = startRotation
        // 考虑当前缩放+旋转后，该向量在屏幕上的实际向量
        let startVector = rotated(cornerVector, by: startRotation) * startScale
        self.startVector = startVector
        self.startLength = vectorLength(startVector)
    }

    /// 用当前手指位移更新换算结果（拖动中持续调用）。
    ///
    /// - Parameter translation: 手指位移，坐标系与 cornerVector 在屏幕上的投影一致
    /// - Returns: 换算得到的缩放倍率与旋转弧度
    public func panChanged(withTranslation translation: CGSize) -> CJGRCornerPanResizeResult {
        var result = CJGRCornerPanResizeResult(scale: startScale, rotation: startRotation)
        guard startLength > 0 else { return result }

        let movedVector = CGSize(width: startVector.width + translation.width,
                                 height: startVector.height + translation.height)
        let movedLength = vectorLength(movedVector)
        guard movedLength > 0 else { return result }

        // 缩放 = 向量长度之比，旋转 = 向量角度之差（右下角点绕中心运动）
        result.scale = (movedLength / startLength) * startScale
        result.rotation = angle(of: movedVector) - angle(of: startVector) + startRotation
        return result
    }

    private func vectorLength(_ vector: CGSize) -> CGFloat {
        sqrt(vector.width * vector.width + vector.height * vector.height)
    }

    private func angle(of vector: CGSize) -> CGFloat {
        atan2(vector.height, vector.width)
    }

    private func rotated(_ vector: CGSize, by radians: CGFloat) -> CGSize {
        let cosValue = CGFloat(cos(radians))
        let sinValue = CGFloat(sin(radians))
        return CGSize(width: vector.width * cosValue - vector.height * sinValue,
                      height: vector.width * sinValue + vector.height * cosValue)
    }
}

private func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}
