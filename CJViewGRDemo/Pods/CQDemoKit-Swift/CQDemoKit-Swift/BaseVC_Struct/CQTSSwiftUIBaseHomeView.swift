//
//  CQTSSwiftUIBaseHomeView.swift
//  CQDemoKit-Swift
//
//  Created by ciyouzen on 2020/2/14.
//  Copyright © 2020 dvlproad. All rights reserved.
//

import SwiftUI

// MARK: - CQTSSwiftUIBaseHomeView

@available(iOS 14.0, *)  // .navigationTitle(title) // 需要iOS14
public struct CQTSSwiftUIBaseHomeView: View {
    private var title: String
    private var sectionDataModels: [CQDMSwiftSectionDataModel] = []
    
    public init(title: String, sectionDataModels: [CQDMSwiftSectionDataModel]) {
        self.title = title
        self.sectionDataModels = sectionDataModels
    }

    public var body: some View {
        List {
            ForEach(sectionDataModels, id: \.theme) { sectionDataModel in
                Section(header: Text(sectionDataModel.theme)) {
                    ForEach(sectionDataModel.values) { moduleModel in
                        if let action = moduleModel.actionBlock {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(moduleModel.title)
                                if let contentText = moduleModel.content {
                                    let contentLines = moduleModel.contentLines ?? 0
                                    Text(contentText)
                                        .lineLimit(contentLines > 1 ? contentLines : 1)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())  // 扩大点击区域
                            .onTapGesture {
                                action()
                            }
                        } else {
                            NavigationLink(
                                destination: self.destinationView(for: moduleModel)
                            ) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(moduleModel.title)
                                    if let contentText = moduleModel.content {
                                        let contentLines = moduleModel.contentLines ?? 0
                                        Text(contentText)
                                            .lineLimit(contentLines > 1 ? contentLines : 1)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .modifier(NavigationTitleModifier(title: title)) // 可选标题
    }
    
    private func destinationView(for moduleModel: CQDMSwiftModuleModel) -> some View {
        if let view = moduleModel.viewGetterHandle?() {
            return view
        }
        return AnyView(Text("No View Found"))
    }
}

// 自定义 Modifier
@available(iOS 14.0, *)
struct NavigationTitleModifier: ViewModifier {
    let title: String?
    
    func body(content: Content) -> some View {
        if let title = title {
            content.navigationTitle(title)
        } else {
            content
        }
    }
}
