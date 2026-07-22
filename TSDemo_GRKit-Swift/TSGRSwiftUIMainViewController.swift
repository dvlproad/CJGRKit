//
//  TSGRSwiftUIMainViewController.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/7/23.
//

import SwiftUI
import CQDemoKit_Swift
import CJBaseUIKit_Swift
import TSDemo_GRKit

@available(iOS 14.0, *)
public struct TSGRSwiftUIMainViewController: View {
    
    public init() {
        
    }
    
    public var body: some View {
        CQTSSwiftUIBaseTabBarView(tabBarModels: [
            CQTSSwiftTabBarModel(
                title: "手势(UIKit)",
                normalImage: Image(systemName: "house"),
                view: NavigationView {
                    ImageGRHomeViewController()
                        .asSwiftUI()
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("手势(UIKit)")
                }
            ),
            CQTSSwiftTabBarModel(
                title: "手势(SwiftUI)",
                normalImage: Image(systemName: "safari"),
                view: TSSwiftUIGRHome()
            ),
            CQTSSwiftTabBarModel(
                title: "手势(UIKit)",
                normalImage: Image(systemName: "house"),
                view: NavigationView {
                    TSGRMainViewController()
                        .asSwiftUI()
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("手势(UIKit)")
                }
            ),
            CQTSSwiftTabBarModel(
                title: "购物",
                normalImage: Image(systemName: "cart"),
                view: NavigationView {
                    List {
                        Section(header: Text("购物车")) {
                            NavigationLink(destination: Text("商品详情")) {
                                Text("商品1")
                            }
                            NavigationLink(destination: Text("订单详情")) {
                                Text("查看订单")
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("购物")
                }
            ),
            CQTSSwiftTabBarModel(
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
    TSGRSwiftUIMainViewController()
}
