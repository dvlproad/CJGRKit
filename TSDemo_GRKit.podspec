Pod::Spec.new do |s|
  s.name         = "TSDemo_GRKit"
  s.version      = "0.0.1"
  s.summary      = "CJGRKit 的演示示例"
  s.homepage     = "https://github.com/dvlproad/CJGRKit.git"

  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }

  s.description  = <<-DESC
                   CJGRKit 各功能模块的演示示例：
                   • UIColor - 颜色分类
                   • UIView - 视图分类（拖拽、摇晃、手势等）
                   • UIButton - 按钮分类
                   • UITextField - 输入框分类
                   • UIScrollView - 滚动视图
                   • UIViewController - 控制器
                   • UINavigationBar - 导航栏
                   • UIWindow - 悬浮窗
                   DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "TSDemo_GRKit_0.0.1" }

  s.frameworks = "UIKit"

  s.requires_arc = true

  s.source_files = "TSDemo_GRKit/**/*.{h,m}"
  s.resource_bundles = { 'TSDemo_GRKit' => ['TSDemo_GRKit/**/*.xib'] }
  # s.prefix_header_contents = '#import <Masonry/Masonry.h>', '#import <CJBaseUIKit/UIColor+CJHex.h>'

  
  s.dependency 'CQDemoKit/BaseVC'
  s.dependency 'CQDemoKit/BaseUtil'
  s.dependency 'CQDemoResource/Images'
  #
  s.dependency 'CJGRKit'
  s.dependency 'CJBaseUIKit/UIView/CJDragAction'

  # # 基础工具
  # s.subspec 'BaseUtil' do |ss|
  #   ss.source_files = "CQDemoKit/BaseUtil/**/*.{h,m}"
  # end
end
