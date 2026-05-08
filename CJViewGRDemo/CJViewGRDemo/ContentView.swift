//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI
import CQDemoKit
import CJViewGR_Swift
import CJViewElement_Swift

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic Gesture Demo") {
                    GestureTestView()
                }

                NavigationLink("Sticker Editor Demo") {
                    CornerButtonGestureTestView()
                }

                NavigationLink("Layout Input + Gesture Demo") {
                    LayoutInputGestureTestView()
                }
            }
            .navigationTitle("CJViewGR Demo")
        }
    }
}

struct GestureTestView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            GestureTestCard()
                .frame(width: 240, height: 180)
                .addGR(minScale: 0.4, maxScale: 4.0)
        }
        .navigationTitle("Basic Gesture")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CornerButtonGestureTestView: View {
    @State private var selectedCardID: Int?

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCardID = nil
                }

            GestureTestCard()
                .frame(width: 240, height: 180)
                .addGR(
                    showCornerButton: selectedCardID == 1,
                    onDelete: {
                        CJUIKitToastUtil.showMessage("Delete first view")
                    },
                    onUpdate: {
                        CJUIKitToastUtil.showMessage("Update first view")
                    },
                    onMinimize: nil,
                    onSelect: {
                        selectedCardID = 1
                    },
                    minScale: 0.4,
                    maxScale: 4.0
                )
                .offset(x: -60, y: -80)
                .zIndex(selectedCardID == 1 ? 1 : 0)

            GestureTestCard(colors: [.blue, .mint],
                            title: "Second View",
                            subtitle: "Select me too")
                .frame(width: 220, height: 160)
                .addGR(
                    showCornerButton: selectedCardID == 2,
                    onDelete: {
                        CJUIKitToastUtil.showMessage("Delete second view")
                    },
                    onUpdate: {
                        CJUIKitToastUtil.showMessage("Update second view")
                    },
                    onMinimize: nil,
                    onSelect: {
                        selectedCardID = 2
                    },
                    minScale: 0.4,
                    maxScale: 4.0
                )
                .offset(x: 70, y: 90)
                .zIndex(selectedCardID == 2 ? 1 : 0)
        }
        .navigationTitle("Sticker Editor")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LayoutInputGestureTestView: View {
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
                                subtitle: "Drag, pinch, rotate")
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

struct GestureTestCard: View {
    var colors: [Color] = [.red, .orange]
    var title: String = "First View"
    var subtitle: String = "Drag, pinch, rotate"

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(colors: colors,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct CJViewGRExtension: View {
    var body: some View {
        GestureTestView()
    }
}

// MARK: 预览 CJViewGRExtension
#Preview {
    ContentView()
}
