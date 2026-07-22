Pod::Spec.new do |s|
  # 上传到github公有库:
  #验证方法1：pod lib lint TSDemo_GRKit-Swift.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint TSDemo_GRKit-Swift.podspec --sources=master --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push TSDemo_GRKit-Swift.podspec --allow-warnings
  
  s.name         = "TSDemo_GRKit-Swift"
  s.version      = "0.0.1"
  s.summary      = "列表相关的Demo"
  s.homepage     = "https://github.com/dvlproad/CJGRKit"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                 列表相关的Demo，可按需独立引入：
                 • TSDemo_GRKit-Swift/RelateTableView - 关联的菜单
                 • TSDemo_GRKit-Swift/LinkedMenu - 可联动的菜单
                 • TSDemo_GRKit-Swift/DouyinUrlAnalyze - 抖音Url解析
                 • TSDemo_GRKit-Swift/ItemPreviewHomePage - 预览型首页
                 • TSDemo_GRKit-Swift/CollectionView_SwiftUI - UI界面

                 每个子库可独立引入，详见各子库描述。
                 DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "11.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit", :tag => "TSDemo_GRKit-Swift_0.0.1" }
  s.source_files  = "TSDemo_GRKit-Swift/TSGRMainViewController.{swift}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.dependency 'CQDemoKit/Demo_Resource'  # 需要使用 UIImage+CQTSInFramework.h
  s.dependency 'CQDemoKit/BaseVC'
  s.dependency 'CQDemoKit-Swift/BaseVC'
  s.dependency 'CQDemoResource/Images'
  s.dependency 'CJBaseUIKit-Swift/UIView/as'

  s.dependency 'TSDemo_GRKit'
#   # 可联动的菜单
#   s.subspec 'LinkedMenu' do |ss|
#     ss.source_files = "TSDemo_GRKit-Swift/LinkedMenu/**/*.{swift}"
#     ss.resources = "TSDemo_GRKit-Swift/LinkedMenu/**/*.{json}"
#     ss.dependency "SnapKit"
#     ss.dependency "CQDemoKit/Demo_DataSourceAndDelegate"
#     ss.dependency "CQDemoResource/Images"
#     ss.dependency "CJBaseUIKit-Swift/Color"
#     ss.dependency "CJFeatureListKit-Swift/LinkedMenu"
#   end

#   # 抖音Url解析
#   s.subspec 'DouyinUrlAnalyze' do |ss|
#     ss.source_files = "TSDemo_GRKit-Swift/DouyinUrlAnalyze/**/*.{swift}"
#     ss.dependency "CJBaseUIKit/UIColor"
#   end
  
#   # 预览型首页
#   s.subspec 'ItemPreviewHomePage' do |ss|
#     ss.source_files = "TSDemo_GRKit-Swift/ItemPreviewHomePage/**/*.{swift}"
#     ss.resources = "TSDemo_GRKit-Swift/ItemPreviewHomePage/**/*.{json}"
# #    ss.dependency "SnapKit"
#     ss.dependency "SDWebImage"
#     ss.dependency 'SDWebImageWebPCoder'
#     ss.dependency "CQDemoKit/Demo_DataSourceAndDelegate"
#     ss.dependency "CJCollectionViewLayout-Swift/LeftAlignedFlowLayout"
#   end
  
  
#   # UI界面
#   s.subspec 'CollectionView_SwiftUI' do |ss|
#     ss.source_files = "TSDemo_GRKit-Swift/CollectionView_SwiftUI/**/*.{swift}"
#     ss.dependency "CJFeatureListKit-Swift/CollectionView_SwiftUI"
#     ss.dependency 'CQDemoKit-Swift/BaseVC'
#   end

end
