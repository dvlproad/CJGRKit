//
//  TSGRSwiftUIMainPage.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/7/23.
//

import SwiftUI
import CJBaseUIKit_Swift

@available(iOS 14.0, *)
public struct TSGRSwiftUIMainPage: View {

    private let mainViewController: TSGRMainViewController

    public init() {
        self.mainViewController = TSGRMainViewController()
    }

    public var body: some View {
        mainViewController.asSwiftUI()
            .ignoresSafeArea()
    }
}

@available(iOS 14.0, *)
#Preview {
    TSGRSwiftUIMainPage()
}
