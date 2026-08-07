//
//  View+CJCornerGR.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

public extension View {
    // 为视图添加边框和三个角按钮：左上删除、右上更新、右下缩小。
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

// 使用ViewModifier为View实现一个扩展，将其添加到一个视图中，该视图中有添加进来的view，view的边缘有边框以及有三个位于该view左上的删除、右上的更新、右下的缩小按钮。
public struct CJGRCornerViewModifier: ViewModifier {
    let onDelete: (() -> Void)
    let onUpdate: (() -> Void)
    let onMinimize: (() -> Void)

    public func body(content: Content) -> some View {
        content
            .overlay(content: {
                CJGRCornerView(zoom: 0.50, onDelete: onDelete, onUpdate: onUpdate, onMinimize: onMinimize)
            })
    }
}
