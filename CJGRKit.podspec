  # 上传到github公有库:
  #验证方法1：pod lib lint CJGRKit.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJGRKit.podspec --sources=cocoapods --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CJGRKit.podspec --allow-warnings --use-libraries --verbose   # 临时添加 --use-libraries 用来解决没错，还是报错的问题
  
  # 上传到私有库(当前使用的)
  #验证方法1：pod lib lint CJGRKit.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJGRKit.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push gitee-dvlproad-dvlproadspecs CJGRKit.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --verbose

  # 上传到开源库
  #验证方法1：pod lib lint CJGRKit.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/Specs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJGRKit.podspec --sources=cocoapods,dvlproadPublicSpec --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproadPublicSpec CJGRKit.podspec --sources=cocoapods,dvlproadPublicSpec --allow-warnings --use-libraries --verbose
Pod::Spec.new do |s|
  s.name         = "CJGRKit"
  s.version      = "0.2.5"
  s.summary      = "可进行各种手势(缩放、拖动(含位置调整))的基于UIView或UIScrollView的视图基类"
  s.homepage     = "https://github.com/dvlproad/CJGRKit.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2020 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
                 各种手势，可按需独立引入：
                 • CJGRKit/CGRectCJSubHelper - 帮助类
                 • CJGRKit/CGRectCJAdjustHelper - 调整移动区域的帮助类
                 • CJGRKit/Extension - 扩展方法
                 • CJGRKit/CJGRView - 自定义的形同 UIScrollView 能够进行拖动和缩放的视图
                 • CJGRKit/CJGRScrollView - 继承系统的 UIScrollView，增加其他限制

                 每个子库可独立引入，详见各子库描述。
                 DESC
  

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJGRKit_0.2.5" }
  #s.source_files  = "CJDemoCommon/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 帮助类
  s.subspec 'CGRectCJSubHelper' do |ss|
    ss.source_files = "CJGRKit/CGRectCJSubHelper/*.{h,m}"
  end

  # 调整移动区域的帮助类
  s.subspec 'CGRectCJAdjustHelper' do |ss|
    ss.source_files = "CJGRKit/CGRectCJAdjustHelper/*.{h,m}"
  end

  # 扩展方法
  s.subspec 'Extension' do |ss| # 当前只有 UIView+CJKeepBounds.h
    ss.source_files = "CJGRKit/Extension/**/*.{h,m}"
    ss.dependency "CJGRKit/CGRectCJAdjustHelper"
  end

  # 自定义的形同 UIScrollView 能够进行拖动和缩放的视图
  s.subspec 'CJGRView' do |ss|
    # CJGRView
    ss.subspec 'Base' do |sss|
      sss.source_files = "CJGRKit/CJGRView/Base/**/*.{h,m}"
      sss.dependency "CJGRKit/CGRectCJAdjustHelper"
    end

    # CJAdjustGRView
    ss.subspec 'BaseAdjustGRView' do |sss|
      sss.source_files = "CJGRKit/CJGRView/BaseAdjustGRView/**/*.{h,m}"
      sss.dependency "CJGRKit/CJGRView/Base"
    end

    # CJImageNormalAdjustGRView-图片普通调整（缩放、拖动）视图，没有裁剪框。场景：如图片拼接里的位置、大小调整。  CJImageClipAdjustGRView-图片裁剪调整（缩放、拖动）视图，有裁剪框。场景：如图片裁剪框里的位置、大小调整。
    ss.subspec 'ImageAdjustGRView' do |sss|
      sss.source_files = "CJGRKit/CJGRView/ImageAdjustGRView/**/*.{h,m}"
      sss.dependency "CJGRKit/CJGRView/BaseAdjustGRView"
      sss.dependency "CJGRKit/CGRectCJSubHelper" # ImageAdjustGRView 中需要使用
    end

    # CJMaskImageAdjustGRView
    ss.subspec 'MaskImageAdjustGRView' do |sss|
      sss.source_files = "CJGRKit/CJGRView/MaskImageAdjustGRView/**/*.{h,m}"
      sss.dependency "CJGRKit/CJGRView/ImageAdjustGRView"
      sss.dependency 'UIPathCJHelper'
    end
    
  end

  # 继承系统的 UIScrollView，增加其他限制
  s.subspec 'CJGRScrollView' do |ss|
    # CJGRScrollView
    ss.subspec 'Base' do |sss|
      sss.source_files = "CJGRKit/CJGRScrollView/Base/**/*.{h,m}"
      sss.dependency "Masonry"
    end

    # CJImageGRScrollView
    ss.subspec 'Image' do |sss|
      sss.source_files = "CJGRKit/CJGRScrollView/Image/**/*.{h,m}"
      sss.dependency 'CJGRKit/CJGRScrollView/Base'
      sss.dependency "CJGRKit/CGRectCJSubHelper"
    end

    # CQMaskCenterView
    ss.subspec 'MaskImage' do |sss|
      sss.source_files = "CJGRKit/CJGRScrollView/MaskImage/**/*.{h,m}"
      sss.dependency 'CJGRKit/CJGRScrollView/Image'
    end
  end
  

  
end
