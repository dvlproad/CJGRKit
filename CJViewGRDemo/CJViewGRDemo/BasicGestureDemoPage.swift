//
//  BasicGestureDemoPage.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/05/09.
//

import SwiftUI
import CJViewGR_Swift

struct BasicGestureDemoPage: View {
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
