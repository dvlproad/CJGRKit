//
//  TSFeatureListHomeViewController.swift
//  TSDemo_List-Swift
//
//  Created by ciyouzen on 2021/2/25.
//  Copyright © 2021年 dvlproad. All rights reserved.
//

import UIKit
import SnapKit
import CQDemoKit
import CQDemoKit_Swift

@objc public class TSFeatureListHomeViewController: CJUIKitBaseHomeViewController {

    private var previewView: TSPreviewView?

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("List首页", comment: "")

        var sectionDataModels: [CQDMSectionDataModel] = []

        // 其他
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "测试 其他 等"
            let module = CQDMModuleModel()
            module.title = "暂无"
            sectionDataModel.values.add(module)
            sectionDataModels.append(sectionDataModel)
        }

        // Cell 和 Header
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "测试 Cell 和 Header 等"

            let cellHomeModule = CQDMModuleModel()
            cellHomeModule.title = "Cell Home"
            cellHomeModule.classEntry = NSClassFromString("TSCellHomeViewController")
            sectionDataModel.values.add(cellHomeModule)

            let settingModule = CQDMModuleModel()
            settingModule.title = "Setting"
            settingModule.classEntry = NSClassFromString("TSSettingViewController")
            sectionDataModel.values.add(settingModule)

            let pickerModule = CQDMModuleModel()
            pickerModule.title = "证件的"
            pickerModule.classEntry = NSClassFromString("PickerImageHomeViewController")
            sectionDataModel.values.add(pickerModule)

            sectionDataModels.append(sectionDataModel)
        }

        // Ad
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "测试 Ad 等"

            let pageControlModule = CQDMModuleModel()
            pageControlModule.title = "广告下的 PageControl"
            pageControlModule.classEntry = NSClassFromString("TSPageControlViewController")
            sectionDataModel.values.add(pageControlModule)

            let cycleADModule = CQDMModuleModel()
            cycleADModule.title = "MyCycleADViewController"
            cycleADModule.classEntry = NSClassFromString("MyCycleADViewController")
            sectionDataModel.values.add(cycleADModule)

            let cycleListModule = CQDMModuleModel()
            cycleListModule.title = "CycleListViewController"
            cycleListModule.classEntry = NSClassFromString("CycleListViewController")
            sectionDataModel.values.add(cycleListModule)

            sectionDataModels.append(sectionDataModel)
        }

        // Menu
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "测试 Menu 等"

            let menuModule = CQDMModuleModel()
            menuModule.title = "水平滚动菜单列表视图(CQMenuCollectionView)"
            menuModule.content = [
                "CJCellHorizontalLayout:水平滚动的collectionView布局(index顺序能按照横向读完再读下一行)",
                "CJFixRowColumnLayout:竖直滚动的collectionView布局"
            ].joined(separator: "\n")
            menuModule.classEntry = NSClassFromString("TSMenuCollectionViewController")
            sectionDataModel.values.add(menuModule)

            sectionDataModels.append(sectionDataModel)
        }

        // 首页(功能列表)
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "首页(功能列表)"

            let featureHomeModule = CQDMModuleModel()
            featureHomeModule.title = "功能列表首页(CJHomeCollectionView)"
            featureHomeModule.content = "CJCollectionViewFlowLayout"
            featureHomeModule.classEntry = NSClassFromString("LEWorkHomeViewController")
            sectionDataModel.values.add(featureHomeModule)

            sectionDataModels.append(sectionDataModel)
        }

        // 首页(预览列表)
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "首页(预览列表)"

            let previewListModule = CQDMModuleModel()
            previewListModule.title = "Item的预览列表"
            previewListModule.content = [
                "常用于外部不提供详情数据，而是用一整张预览图来展示",
                "CJLeftAlignedFlowLayout(已解决布局)",
                "UICollectionViewFlowLayout(使用系统有布局问题)"
            ].joined(separator: "\n")
            previewListModule.contentLines = 0
            previewListModule.viewGetterHandle = { [weak self] in
                let containerView = UIView()

                let bugButton = CQTSButtonFactory.bugButton(withBugHappen: false, fixBugHandle: {
                    self?.previewView?.updateLayoutToNormal(toNormal: false)
                }, reproduceBugHandle: {
                    self?.previewView?.updateLayoutToNormal(toNormal: true)
                })
                containerView.addSubview(bugButton)
                bugButton.snp.makeConstraints { make in
                    make.centerX.equalTo(containerView)
                    make.left.equalTo(containerView).offset(10)
                    make.top.equalTo(containerView).offset(20)
                    make.height.equalTo(44)
                }

                let previewView = TSPreviewView(onTapEntity: { previewModel in
                    let message = "点击了预览项: \(previewModel.name)"
                    CJUIKitToastUtil.showMessage(message)
                })
                containerView.addSubview(previewView)
                previewView.snp.makeConstraints { make in
                    make.centerX.equalTo(bugButton)
                    make.left.equalTo(containerView)
                    make.top.equalTo(bugButton.snp.bottom).offset(20)
                    make.height.equalTo(640)
                }
                self?.previewView = previewView

                return containerView
            }
            sectionDataModel.values.add(previewListModule)

            sectionDataModels.append(sectionDataModel)
        }

        // ExtralItem
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "测试 ExtralItem 等"

            let extralItemModule = CQDMModuleModel()
            extralItemModule.title = "TSExtralItemCollectionViewController"
            extralItemModule.content = ["CJExtralItemCollectionViewDataSource"].joined(separator: "\n")
            extralItemModule.contentLines = 0
            extralItemModule.classEntry = NSClassFromString("TSExtralItemCollectionViewController")
            sectionDataModel.values.add(extralItemModule)

            let extralTagModule = CQDMModuleModel()
            extralTagModule.title = "自定义标签页(CQExtralTagSeletedCollectionView)--含ExtralItem功能"
            extralTagModule.content = [
                "CJWarpFlowLayout",
                "CJExtralItemCollectionViewDataSource"
            ].joined(separator: "\n")
            extralTagModule.contentLines = 0
            extralTagModule.classEntry = NSClassFromString("TSExtralTagCollectionViewController")
            sectionDataModel.values.add(extralTagModule)

            sectionDataModels.append(sectionDataModel)
        }

        // SwiftUI
        do {
            let sectionDataModel = CQDMSectionDataModel()
            sectionDataModel.theme = "SwiftUI"

            let gridViewModule1 = CQDMModuleModel()
            gridViewModule1.title = "多行的滚动视图(SwiftUI)"
            gridViewModule1.content = "每行4个，不够继续下一行\n视图高度自动适配"
            gridViewModule1.contentLines = 2
            gridViewModule1.viewGetterHandle = {
                if #available(iOS 14.0, *) {
                    return TSSwiftUIGridViewUIView(itemsPerRow: 4, cellItemSpacing: 20, cellWidth: 70.0, rowHeight: 70.0, maxRowCount: 9999)
                } else {
                    return UIView()
                }
            }
            sectionDataModel.values.add(gridViewModule1)

            let gridViewModule2 = CQDMModuleModel()
            gridViewModule2.title = "多行的滚动视图(SwiftUI)"
            gridViewModule2.content = "每行4个，不够继续下一行\n视图高度自动适配，最多2行"
            gridViewModule2.contentLines = 2
            gridViewModule2.viewGetterHandle = {
                if #available(iOS 14.0, *) {
                    return TSSwiftUIGridViewUIView(itemsPerRow: 4, cellItemSpacing: 20, cellWidth: 70.0, rowHeight: 70.0, maxRowCount: 2)
                } else {
                    return UIView()
                }
            }
            sectionDataModel.values.add(gridViewModule2)

            let singleScrollModule = CQDMModuleModel()
            singleScrollModule.title = "单行或者单列滚动的视图，且可额外设置头尾视图。(SwiftUI)"
            singleScrollModule.content = ""
            singleScrollModule.contentLines = 2
            singleScrollModule.viewGetterHandle = {
                if #available(iOS 14.0, *) {
                    let swiftUIView = IconScrollView(
                        currentDataModel: .constant(nil),
                        enableTintColor: .constant(true),
                        onChangeOfDataModel: {
                            newDataModel in
                        },
                        onTapMore: {
                            
                        }
                    )
                    return swiftUIView.asUIKit()
                    return CQTSSwiftUIAsUIView.init(swiftUIView: swiftUIView)
                } else {
                    return UIView()
                }
            }
            sectionDataModel.values.add(singleScrollModule)

            sectionDataModels.append(sectionDataModel)
        }

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
