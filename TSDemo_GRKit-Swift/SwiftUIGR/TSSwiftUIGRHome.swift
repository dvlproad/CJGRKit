//
//  TSSwiftUIGRHome.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/7/23.
//

import SwiftUI
import CQDemoKit_Swift

public struct TSSwiftUIGRHome: View {
    public init() {
        
    }
    
    public var body: some View {
        NavigationView {
            CQTSSwiftUIBaseHomeView(
                title: "手势(SwiftUI)",
                sectionDataModels: [
                    CQDMSwiftSectionDataModel(
                        theme: "手势功能",
                        values: [
                            CQDMSwiftModuleModel(
                                title: "Basic Gesture Demo",
                                viewGetterHandle: {
                                    AnyView(BasicGestureDemoPage())
                                }
                            ),
                            CQDMSwiftModuleModel(
                                title: "Sticker Editor Demo",
                                viewGetterHandle: {
                                    AnyView(StickerEditorDemoPage())
                                }
                            ),
                            CQDMSwiftModuleModel(
                                title: "Layout Input + Gesture Demo1",
                                viewGetterHandle: {
                                    AnyView(LayoutInputGestureDemoPage())
                                }
                            ),
                            CQDMSwiftModuleModel(
                                title: "Layout Model + Gesture Demo2",
                                viewGetterHandle: {
                                    AnyView(LayoutInputGestureDemoPage2())
                                }
                            )
                        ]
                    )
                ]
            )
        }
    }
}
