//
//  LayoutInputGestureDemoPage.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/05/09.
//

import SwiftUI
import CQDemoKit
import CJViewGR_Swift
import CJViewElement_Swift

struct LayoutInputGestureDemoPage: View {
    @State private var left: CGFloat = 60
    @State private var top: CGFloat = 70
    @State private var width: CGFloat = 220
    @State private var height: CGFloat = 150
    @State private var scale: CGFloat = 1
    @State private var rotationDegrees: CGFloat = 0
    @State private var refreshID: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                Color(.systemGroupedBackground)

                GestureTestCard(colors: [.purple, .pink],
                                title: "Layout Linked",
                                subtitle: "Drag, pinch, rotate",
                                textScale: scale)
                    .frame(width: width, height: height)
                    // 这里先按 layout 放置原始内容盒子，再把持久旋转交给 addGR(baseRotation:)。
                    // 手势结束后把临时变换写回下面的 CJLayoutInputView，方便观察两边状态是否同步。
                    .addGR(
                        showCornerButton: true,
                        onDelete: {
                            CJUIKitToastUtil.showMessage("Delete")
                        },
                        onUpdate: {
                            CJUIKitToastUtil.showMessage("Update")
                        },
                        onMinimize: nil,
                        onSelect: nil,
                        onTransformEnded: applyTransform,
                        baseRotation: .degrees(rotationDegrees),
                        minScale: 0.4,
                        maxScale: 4.0
                    )
                    .offset(x: left, y: top)
                    .id("layout-gesture-card-\(refreshID)")
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)

            CJLayoutInputView(
                left: $left,
                top: $top,
                width: $width,
                height: $height,
                scale: $scale,
                rotationDegrees: $rotationDegrees,
                onChange: {
                    // layout 输入框直接改 @State，SwiftUI 会刷新预览。
                    // 额外递增 id 是为了让 addGR 重新读取最新 baseRotation，并清掉手势内部临时状态。
                    refreshID += 1
                }
            )
            .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 4) {
                Text("left/top: \(Int(left)), \(Int(top))")
                Text("size: \(Int(width)) x \(Int(height))")
                Text(String(format: "scale: %.2f", Double(scale)))
                Text("rotation: \(Int(rotationDegrees))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()
        }
        .navigationTitle("Layout + Gesture")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func applyTransform(_ transform: CJGRTransformResult) {
        left += transform.translation.width
        top += transform.translation.height

        if transform.scale != 1 {
            let oldWidth = width
            let oldHeight = height
            let newWidth = max(1, oldWidth * transform.scale)
            let newHeight = max(1, oldHeight * transform.scale)

            left -= (newWidth - oldWidth) / 2
            top -= (newHeight - oldHeight) / 2
            width = newWidth
            height = newHeight
            scale *= transform.scale
        }

        let deltaRotationDegrees = CGFloat(transform.rotation.degrees)
        if deltaRotationDegrees != 0 {
            rotationDegrees += deltaRotationDegrees
        }

        // addGR 内部的临时 offset/scale/rotation 会在回调后清零。
        // 这里强制重建演示卡片，让它立即按新的 layout 状态显示。
        refreshID += 1
    }
}
