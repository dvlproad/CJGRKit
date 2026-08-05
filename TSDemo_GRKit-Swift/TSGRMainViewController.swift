//
//  TSGRMainViewController.swift
//  TSDemo_GRKit-Swift
//
//  Created by qian on 2026/8/5.
//

import UIKit
import SwiftUI
import CQDemoKit
import CQDemoKit_Swift
import TSDemo_GRKit

@objc public class TSGRMainViewController: CJUIKitBaseTabBarViewController {

    // CJUIKitBaseTabBarViewController 会把 tabBarItem.image 强制设为 AlwaysOriginal（保留原图颜色），
    // 对 SF Symbol 会导致未选中时也有颜色。这里恢复成系统默认的 template 渲染（未选中置灰、选中变主题色）
    public override var tabBarModels: [CQDMTabBarModel] {
        get { super.tabBarModels }
        set {
            super.tabBarModels = newValue
            for child in viewControllers ?? [] {
                child.tabBarItem.image = child.tabBarItem.image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        var tabBarModels: [CQDMTabBarModel] = []

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("GRExtension", comment: "")
            model.normalImage = UIImage(systemName: "cart")
            model.classEntry = TSViewGRExtensionHomeViewController.self
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("手势(UIKit)", comment: "")
            model.normalImage = UIImage(systemName: "house")
            model.classEntry = ImageGRHomeViewController.self
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("手势(UIKit)", comment: "")
            model.normalImage = UIImage(systemName: "house")
            model.classEntry = TSGRScrollViewHomeViewController.self
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("手势(SwiftUI)", comment: "")
            model.normalImage = UIImage(systemName: "safari")
            model.viewControllerGetterHandle = {
                return TSSwiftUIGRHome().cqts_embedToUIViewController()
            }
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("我的", comment: "")
            model.normalImage = UIImage(systemName: "person")
            model.viewControllerGetterHandle = {
                let mineView = NavigationView {
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
                return CJGRSwiftUIHostViewController(rootView: mineView)
            }
            tabBarModels.append(model)
        }

        self.tabBarModels = tabBarModels
    }
}

// 承载自带 NavigationView 的 SwiftUI 视图，并隐藏外层 UINavigationController 的导航栏，
// 避免出现双层导航栏（CJUIKitBaseTabBarViewController 会自动为每个 root 包一层 UINavigationController）
@available(iOS 14.0, *)
private class CJGRSwiftUIHostViewController: UIViewController {
    private let hostingController: UIHostingController<AnyView>

    init<Content: View>(rootView: Content) {
        self.hostingController = UIHostingController(rootView: AnyView(rootView))
        super.init(nibName: nil, bundle: nil)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
