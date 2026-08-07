# ------------------------------------------------
#  pod trunk register 邮箱地址 '用户名' --description='描述信息'
#  pod trunk register dvlproad@163.com 'dvlproad' --description='homeMac'
#  pod trunk me

# pod的本地索引文件：~/Library/Caches/CocoaPods/search_index.json
# pod的owner操作：https://www.jianshu.com/p/a9b8c2a1f3cf

# ------------------------------------------------
  # 上传到github公有库:(当前使用的)
  #验证方法1：pod lib lint CJViewGR-Swift.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJViewGR-Swift.podspec --sources=cocoapods --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CJViewGR-Swift.podspec --allow-warnings --use-libraries --verbose   # 临时添加 --use-libraries 用来解决没错，还是报错的问题
  
Pod::Spec.new do |s|
  s.name         = "CJViewGR-Swift"
  s.version      = "0.0.4"
  s.summary      = "Swift版的视图手势操作扩展库"
  s.homepage     = "https://github.com/dvlproad/CJGRKit.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                 SwiftUI 视图手势能力，按能力拆分、可独立引入：
                 • CJViewGR-Swift/AnyGR - 基础手势修饰器（拖动/双指缩放/双指旋转）及便捷入口 addGR（含角按钮开关 showCornerButton），依赖 CornerGR
                 • CJViewGR-Swift/CornerGR - 角按钮编辑层（便捷入口 addGRButtons、CJGRCornerViewModifier、CJGRCornerView 角按钮 UI、CJGRCornerPanResizeCalculator 右下缩放旋转计算器），供 AnyGR 使用

                 每个子库可独立引入，详见各子库描述。
                 DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "17.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJViewGR-Swift_0.0.4" }
  s.frameworks = 'UIKit'

  s.requires_arc = true

  # 基础手势能力：拖动、双指缩放、双指旋转 + 便捷入口 addGR
  s.subspec 'AnyGR' do |ss|
    ss.source_files = "CJViewGR-Swift/AnyGR/**/*.{swift}"
    ss.dependency 'CJViewGR-Swift/CornerGR'
  end

  # 角按钮编辑层：便捷入口 addGRButtons + CJGRCornerViewModifier + CJGRCornerView + 右下缩放旋转计算器（被 AnyGR 依赖）
  s.subspec 'CornerGR' do |ss|
    ss.source_files = "CJViewGR-Swift/CornerGR/**/*.{swift}"
  end

end
