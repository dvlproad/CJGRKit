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
  s.version      = "0.0.2"
  s.summary      = "Swift版的视图手势操作扩展库"
  s.homepage     = "https://github.com/dvlproad/CJGRKit.git"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                   A longer description of CJViewGR-Swift in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.description  = <<-DESC
                 UICollectionViewLayout 集合：支持固定行列数、左对齐、水平分页、封面浏览、瀑布流、主次/主次末布局，可按需独立引入：
                 • CJCollectionViewLayout/FixedRowColumnLayout - 固定行列数均分布局
                 • CJCollectionViewLayout/HorizontalLayout - 水平滚动且【计数是从前一行的左到右，然后再到下一行的左到右】的布局（系统的水平滚动时，计数是从第一列上到下，然后再到第二列的）
                 • CJCollectionViewLayout/CoverFlowLayout - 封面浏览效果的布局(卡片切换布局)
                 • CJCollectionViewLayout/WarpFlowLayout - Wrap自动折行左对齐(Swift版:CJLeftAlignedFlowLayout; OC版:CJWarpFlowLayout)
                 • CJCollectionViewLayout/MainSubLayout - 主次布局(两种cell：主mainCell、次subCell)
                 • CJCollectionViewLayout/MainSubLastLayout - 主次尾部布局(三种cell：主mainCell、次subCell、最后的角落cell)

                 每个子库可独立引入，详见各子库描述。
                 DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "17.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJViewGR-Swift_0.0.2" }
  # s.source_files  = "CJViewGR-Swift/**/*.{swift}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 基础的帮助类
  s.subspec 'Extension' do |ss|
    ss.source_files = "CJViewGR-Swift/View/**/*.{swift}"
#    ss.dependency "CJDataVientianeSDK_Swift"#,   :path => '../../../../CJDataVientianeSDK'
  end

end
