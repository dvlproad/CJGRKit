Pod::Spec.new do |s|
  #验证方法：pod lib lint CJViewGR-Swift.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJViewGR-Swift"
  s.version      = "0.0.1"
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

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "17.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJViewGR-Swift_0.0.1" }
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
