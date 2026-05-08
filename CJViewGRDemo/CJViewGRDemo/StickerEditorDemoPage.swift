//
//  StickerEditorDemoPage.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/05/09.
//

import SwiftUI
import CQDemoKit
import CJViewGR_Swift

struct StickerEditorDemoPage: View {
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
