//
//  ContentView.swift
//  CJViewGRDemo
//
//  Created by qian on 2024/11/27.
//

import SwiftUI
import CJBaseUIKit_Swift
import CQDemoKit_Swift
import TSDemo_GRKit
import TSDemo_GRKit_Swift

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

                NavigationLink("Layout Input + Gesture Demo1") {
                    LayoutInputGestureDemoPage()
                }

                NavigationLink("Layout Model + Gesture Demo2") {
                    LayoutInputGestureDemoPage2()
                }
                
                NavigationLink("ImageGRHome") {
                    ImageGRHomeViewController()
                        .asSwiftUI()
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
