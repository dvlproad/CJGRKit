//
//  GestureTestCard.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/05/09.
//

import SwiftUI

struct GestureTestCard: View {
    var colors: [Color] = [.red, .orange]
    var title: String = "First View"
    var subtitle: String = "Drag, pinch, rotate"
    var textScale: CGFloat = 1

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
                    .font(.system(size: 22 * clampedTextScale, weight: .bold))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.system(size: 15 * clampedTextScale))
                    .foregroundStyle(.white.opacity(0.8))
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var clampedTextScale: CGFloat {
        min(max(textScale, 0.4), 4.0)
    }
}
