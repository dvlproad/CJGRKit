//
//  CJViewGRExtension.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

// 扩展View，添加一个修饰符，用于应用RedBackgroundModifier
public extension View {
    public func redBackground(color: Color = .red, cornerRadius: CGFloat = 0, padding: CGFloat = 0) -> some View {
        self.modifier(
            RedBackgroundModifier(color: color,
                                  cornerRadius: cornerRadius,
                                  padding: padding)
        )
    }
    
    
    public func addGR(enableGR: Bool = true, grModel: String = "", showCornerButton: Bool = true) -> some View {
        self.modifier(
//            CJGRViewModifier(imageModel: grModel)
            CJGRViewModifier()
        )
    }
    
    
    // 为视图添加边框和三个角按钮
    public func addGRButtons(onDelete: @escaping () -> Void,
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


