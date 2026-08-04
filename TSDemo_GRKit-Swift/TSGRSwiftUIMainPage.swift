//
//  TSGRSwiftUIMainPage.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/7/23.
//

import SwiftUI
import CQDemoKit_Swift
import CJBaseUIKit_Swift
import TSDemo_GRKit

@available(iOS 14.0, *)
public struct TSGRSwiftUIMainPage: View {
    
    public init() {
        
    }
    
    public var body: some View {
        CQTSSwiftUIBaseTabBarView(tabBarModels: [
            CQTSSwiftUITabBarModel(
                title: "GRExtension",
                normalImage: Image(systemName: "cart"),
                view: NavigationView {
                    TSViewGRExtensionHomeViewController()
                        .asSwiftUI()
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("GRExtension")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "手势(UIKit)",
                normalImage: Image(systemName: "house"),
                view: NavigationView {
                    ImageGRHomeViewController()
                        .asSwiftUI()
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("手势(UIKit:GRView)")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "手势(UIKit)",
                normalImage: Image(systemName: "house"),
                view: NavigationView {
                    TSGRScrollViewHomeViewController()
                        .asSwiftUI()
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("手势(UIKit:GRScrollView)")
                }
            ),
            CQTSSwiftUITabBarModel(
                title: "手势(SwiftUI)",
                normalImage: Image(systemName: "safari"),
                view: TSSwiftUIGRHome()
            ),
            CQTSSwiftUITabBarModel(
                title: "我的",
                normalImage: Image(systemName: "person"),
                view: NavigationView {
                    List {
                        Section(header: Text("个人中心")) {
                            NavigationLink(destination: Text("个人资料")) {
                                Text("编辑资料")
                            }
                            NavigationLink(destination: Text("设置页面")) {
                                Text("设置")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("我的")
                }
            )
        ])
    }
}

@available(iOS 14.0, *)
#Preview {
    TSGRSwiftUIMainPage()
}
