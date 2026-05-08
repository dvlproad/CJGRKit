//
//  LayoutInputGestureDemoPage2.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/05/09.
//

import SwiftUI
import CQDemoKit
import CJViewGR_Swift
import CJViewElement_Swift

struct LayoutInputGestureDemoPage2: View {
    @State private var layout: CJTextLayoutModel = {
        let layout = CJTextLayoutModel()
        layout.left = 52
        layout.top = 72
        layout.width = 240
        layout.height = 130
        layout.scale = 1
        layout.rotationDegrees = 0
        layout.fontSize = 24
        layout.fontWeight = .bold
        layout.foregroundColor = "#FFFFFF"
        layout.textAlignment = .center
        layout.lineLimit = 2
        layout.backgroundColor = "#2F80ED"
        layout.borderCornerRadius = 12
        return layout
    }()
    @State private var refreshID: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                Color(.systemGroupedBackground)

                Text("CJTextLayoutModel\nlayout + addGR")
                    .property(layout)
                    // 这个页面专门验证 SDK 的 layout(decorateContent:) 链路：
                    // Text 先按 CJTextLayoutModel 生成内容盒子，再把 addGR 插进去，最后由 layout 负责 left/top。
                    // 因为文本缩放已经通过 property(layout) 的 fontSize * scale 烘焙进内容，所以这里不能再传 baseScale。
                    .layout(layout) { content in
                        content.addGR(
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
                            baseRotation: .degrees(layout.rotationDegrees),
                            minScale: 0.4,
                            maxScale: 4.0
                        )
                    }
                    .id("layout-model-card-\(refreshID)")
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)

            CJLayoutInputView(
                left: $layout.left,
                top: $layout.top,
                width: $layout.width,
                height: $layout.height,
                scale: $layout.scale,
                rotationDegrees: $layout.rotationDegrees,
                onChange: {
                    // layout 是 class，字段变化不会让 @State 引用本身变化。
                    // 这里主动刷新，让预览重新按最新 layout 绘制，并清掉 addGR 的临时手势状态。
                    refreshID += 1
                }
            )
            .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 4) {
                Text("left/top: \(Int(layout.left)), \(Int(layout.top))")
                Text("size: \(Int(layout.width)) x \(Int(layout.height))")
                Text(String(format: "scale: %.2f", Double(layout.scale)))
                Text("rotation: \(Int(layout.rotationDegrees))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()
        }
        .navigationTitle("Layout Model + Gesture")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func applyTransform(_ transform: CJGRTransformResult) {
        // simultaneous gesture 结束时可能额外抛出一次没有视觉变化的空回调。
        // 空回调如果也重建视图，放手瞬间容易看起来像抖了一下。
        guard transform.hasVisibleChange else {
            return
        }

        layout.left += transform.translation.width
        layout.top += transform.translation.height

        if transform.scale != 1 {
            // Page2 走 CJTextLayoutModel 的“烘焙进内容盒子”路线。
            // 手势中的 scaleEffect 会把整个内容盒子按中心放大/缩小；
            // 写回时也必须同步修改 width/height，并补偿 left/top 保持中心不跳。
            let oldScale = max(layout.scale, 0.01)
            let newScale = min(max(oldScale * transform.scale, 0.4), 4.0)
            let appliedScale = newScale / oldScale
            let oldWidth = layout.width
            let oldHeight = layout.height
            let newWidth = max(1, oldWidth * appliedScale)
            let newHeight = max(1, oldHeight * appliedScale)

            layout.left -= (newWidth - oldWidth) / 2
            layout.top -= (newHeight - oldHeight) / 2
            layout.width = newWidth
            layout.height = newHeight
            layout.scale = newScale
        }

        let deltaRotationDegrees = CGFloat(transform.rotation.degrees)
        if deltaRotationDegrees != 0 {
            layout.rotationDegrees += deltaRotationDegrees
        }

        // addGR 会在回调后清空内部临时 transform。
        // 重建视图可以让它马上读取最新 baseRotation，并显示已写回的 CJTextLayoutModel。
        refreshID += 1
    }
}

private extension CJGRTransformResult {
    var hasVisibleChange: Bool {
        abs(translation.width) > 0.01 ||
        abs(translation.height) > 0.01 ||
        abs(scale - 1) > 0.001 ||
        abs(rotation.degrees) > 0.01
    }
}

#Preview {
    NavigationStack {
        LayoutInputGestureDemoPage2()
    }
}
