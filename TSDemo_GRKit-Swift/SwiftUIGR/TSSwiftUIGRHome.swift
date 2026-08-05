//
//  TSSwiftUIGRHome.swift
//  CJViewGRDemo
//
//  Created by qian on 2026/7/23.
//

import SwiftUI
import CQDemoKit_Swift

public struct TSSwiftUIGRHome: View {
    // 由外层 UIKit 宿主注入：通过外层 UINavigationController push 目标页面，
    // 从而 hidesBottomBarWhenPushed 生效，能隐藏底部 tab（而不是用 SwiftUI 内部的 NavigationLink）
    public var push: (AnyView, String) -> Void

    public init(push: @escaping (AnyView, String) -> Void = { _, _ in }) {
        self.push = push
    }

    /// 将本视图包装为 UIViewController：列表项的跳转改由外层 UINavigationController push，
    /// 并设置 hidesBottomBarWhenPushed，从而 push 时能隐藏底部 tab（UIKit 标准行为）。
    public func cqts_embedToUIViewController() -> UIViewController {
        return TSSwiftUIGRHomeHostViewController(home: self)
    }

    public var body: some View {
        CQTSSwiftUIBaseHomeView(
            title: "手势(SwiftUI)",
            sectionDataModels: [
                CQDMSwiftUISectionDataModel(
                    theme: "手势功能",
                    values: [
                        CQDMSwiftUIModuleModel(
                            title: "Basic Gesture Demo",
                            actionBlock: {
                                push(AnyView(BasicGestureDemoPage()), "Basic Gesture Demo")
                            }
                        ),
                        CQDMSwiftUIModuleModel(
                            title: "Sticker Editor Demo",
                            actionBlock: {
                                push(AnyView(StickerEditorDemoPage()), "Sticker Editor Demo")
                            }
                        ),
                        CQDMSwiftUIModuleModel(
                            title: "Layout Input + Gesture Demo1",
                            actionBlock: {
                                push(AnyView(LayoutInputGestureDemoPage()), "Layout Input + Gesture Demo1")
                            }
                        ),
                        CQDMSwiftUIModuleModel(
                            title: "Layout Model + Gesture Demo2",
                            actionBlock: {
                                push(AnyView(LayoutInputGestureDemoPage2()), "Layout Model + Gesture Demo2")
                            }
                        )
                    ]
                )
            ]
        )
    }
}

// 手势(SwiftUI) 页面的宿主：不内嵌 NavigationView，跳转改由外层 UINavigationController push
// 目标页面（包成 UIHostingController），并设置 hidesBottomBarWhenPushed = true，
// 这样底部 tab 会在 push 时自动隐藏、pop 时恢复（UIKit 标准行为）。
@available(iOS 14.0, *)
private class TSSwiftUIGRHomeHostViewController: UIViewController {
    private let hostingController: UIHostingController<AnyView>

    init(home: TSSwiftUIGRHome) {
        var home = home
        let hostingController = UIHostingController(rootView: AnyView(home))
        self.hostingController = hostingController
        super.init(nibName: nil, bundle: nil)

        home.push = { [weak self] view, title in
            guard let self, let navigationController = self.navigationController else { return }
            let detailVC = UIHostingController(rootView: view)
            detailVC.hidesBottomBarWhenPushed = true
            detailVC.navigationItem.title = title
            navigationController.pushViewController(detailVC, animated: true)
        }
        hostingController.rootView = AnyView(home)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
