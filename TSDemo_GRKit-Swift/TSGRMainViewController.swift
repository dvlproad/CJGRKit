//
//  TSGRMainViewController.swift
//  TSDemo_GRKit-Swift
//
//  Created by ciyouzen on 2021/2/25.
//  Copyright © 2021年 dvlproad. All rights reserved.
//

import UIKit
import CQDemoKit
import CQDemoResource
import TSDemo_GRKit

@objc public class TSGRMainViewController: CJUIKitBaseTabBarViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        var tabBarModels: [CQDMTabBarModel] = []

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("CJGRView", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-home")
            model.classEntry = NSClassFromString("ImageGRHomeViewController")
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("CJGRScrollView", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-calendar")
            model.classEntry = NSClassFromString("ImageGRHomeViewController")
            tabBarModels.append(model)
        }

        /*
        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Action", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("TSCollectionViewActionHomeViewController")
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Feature", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-menu")
            model.classEntry = TSFeatureListHomeViewController.self
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("LinkedMenu", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-settings")
            model.classEntry = LinkedMenuHomeViewController.self
            tabBarModels.append(model)
        }
        */

        self.tabBarModels = tabBarModels
    }
}
