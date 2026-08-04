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
                    CQDMSwiftUISectionDataModel(
                        theme: "手势功能",
                        values: [
                            CQDMSwiftUIModuleModel(
                                title: "Basic Gesture Demo",
                                viewGetterHandle: {
                                    AnyView(BasicGestureDemoPage())
                                }
                            ),
                            CQDMSwiftUIModuleModel(
                                title: "Sticker Editor Demo",
                                viewGetterHandle: {
                                    AnyView(StickerEditorDemoPage())
                                }
                            ),
                            CQDMSwiftUIModuleModel(
                                title: "Layout Input + Gesture Demo1",
                                viewGetterHandle: {
                                    AnyView(LayoutInputGestureDemoPage())
                                }
                            ),
                            CQDMSwiftUIModuleModel(
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
