//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI
import CQDemoKit
import CJViewGR_Swift

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
