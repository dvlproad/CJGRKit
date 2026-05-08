//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic Gesture Demo") {
                    BasicGestureDemoPage()
                }

                NavigationLink("Sticker Editor Demo") {
                    StickerEditorDemoPage()
                }

                NavigationLink("Layout Input + Gesture Demo") {
                    LayoutInputGestureDemoPage()
                }
            }
            .navigationTitle("CJViewGR Demo")
        }
    }
}

struct CJViewGRExtension: View {
    var body: some View {
        BasicGestureDemoPage()
    }
}

// MARK: 预览 CJViewGRExtension
#Preview {
    ContentView()
}
