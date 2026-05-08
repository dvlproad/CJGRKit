//
//  CJViewGRExtension.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

public extension View {
    // 调试用背景修饰符。
    func redBackground(color: Color = .red, cornerRadius: CGFloat = 0, padding: CGFloat = 0) -> some View {
        self.modifier(
            RedBackgroundModifier(color: color,
                                  cornerRadius: cornerRadius,
                                  padding: padding)
        )
    }
    
    
    // 为视图添加基础手势能力：拖动、双指缩放、双指旋转。
    func addGR(enableGR: Bool = true,
               grModel: String = "",
               showCornerButton: Bool = true,
               minScale: CGFloat = 0.3,
               maxScale: CGFloat = 6.0) -> some View {
        addGR(enableGR: enableGR,
              grModel: grModel,
              showCornerButton: showCornerButton,
              onDelete: nil,
              onUpdate: nil,
                      onMinimize: nil,
                      onSelect: nil,
                      onTransformEnded: nil,
                      baseScale: 1,
                      baseRotation: .zero,
                      minScale: minScale,
                      maxScale: maxScale)
    }

    // 为视图添加完整贴纸编辑能力。showCornerButton 通常由外部选中态控制；
    // onSelect 会在点击、拖动、缩放、旋转和右下角操作柄拖动时触发。
    //
    // baseScale/baseRotation 用来传入外部已经持久化的缩放和旋转。
    //
    // 注意 baseScale 只适合“缩放作为独立变换保存”的场景：内容仍按原始 width/height 渲染，
    // 视觉缩放由 addGR 内部统一执行。这样内容、边框、角按钮和手势临时缩放处在同一坐标系里。
    //
    // 如果业务已经把缩放烘焙进内容盒子，例如同步修改了 width/height，或文本使用 fontSize * scale 渲染，
    // 那么内容本身已经是缩放后的尺寸，不要再把同一个 scale 传给 baseScale，否则会双重缩放。
    //
    // 对持久旋转也类似：不要在 addGR 外层再写 .rotationEffect(...)；
    // 应该通过 baseRotation 交给 addGR 内部统一处理，避免边框、角按钮和手势坐标错位。
    //
    // onTransformEnded 返回的是本次手势结束时的相对变化：
    // - translation 是本次拖动增量；
    // - scale 是本次缩放倍率；
    // - rotation 是本次旋转增量。
    // 外部写回模型后，addGR 会清掉内部临时状态，避免双重位移、双重缩放或双重旋转。
    func addGR(enableGR: Bool = true,
               grModel: String = "",
               showCornerButton: Bool = true,
               onDelete: (() -> Void)?,
               onUpdate: (() -> Void)?,
               onMinimize: (() -> Void)?,
               onSelect: (() -> Void)? = nil,
               onTransformEnded: ((CJGRTransformResult) -> Void)? = nil,
               baseScale: CGFloat = 1,
               baseRotation: Angle = .zero,
               minScale: CGFloat = 0.3,
               maxScale: CGFloat = 6.0) -> some View {
        self.modifier(
//            CJGRViewModifier(imageModel: grModel)
            CJGRViewModifier(enableGR: enableGR,
                             showCornerButton: showCornerButton,
                             onDelete: onDelete,
                             onUpdate: onUpdate,
                             onMinimize: onMinimize,
                             onSelect: onSelect,
                             onTransformEnded: onTransformEnded,
                             baseScale: baseScale,
                             baseRotation: baseRotation,
                             minScale: minScale,
                             maxScale: maxScale)
        )
    }
    
    
    // 为视图添加边框和三个角按钮
    func addGRButtons(onDelete: @escaping () -> Void,
                      onUpdate: @escaping () -> Void,
                      onMinimize: @escaping () -> Void
    ) -> some View {
        self.modifier(CJGRCornerViewModifier(
            onDelete: onDelete,
            onUpdate: onUpdate,
            onMinimize: onMinimize
        ))
    }
}





// 自定义ViewModifier，接受参数以自定义红色背景视图的样式
public struct RedBackgroundModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat
    var padding: CGFloat

    public func body(content: Content) -> some View {
        content
//            .padding(padding) // 添加内边距
            .background(color) // 应用红色背景
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 应用圆角
//            .border(Color.green, width: padding)
        
    }
}
