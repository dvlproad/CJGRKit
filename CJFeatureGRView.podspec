Pod::Spec.new do |s|
  # 上传到私有库
  #验证方法1：pod lib lint CJFeatureGRView.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJFeatureGRView.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push gitee-dvlproad-dvlproadspecs CJFeatureGRView.podspec --sources=cocoapods,gitee-dvlproad-dvlproadspecs --allow-warnings --use-libraries --verbose

  s.name         = "CJFeatureGRView"
  s.version      = "0.1.0"
  s.summary      = "基于 CJGRKit 手势能力的业务组件库（图片调整、图片裁剪）"
  s.homepage     = "https://github.com/dvlproad/CJGRKit.git"

  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE'
  }

  s.author   = { "dvlproad" => "dvlproad@163.com" }

  s.description  = <<-DESC
                   CJFeatureGRView - 基于 CJGRKit 手势能力的业务组件库

                   • CJFeatureGRView/ImageAdjustGRView - CJImageAdjustGRView.h 图片调整（缩放、拖动）视图，有裁剪窗口无蒙层
                   • CJFeatureGRView/MaskImageAdjustGRView - CJMaskImageAdjustGRView.h 图片裁剪编辑完整组件（继承基类 + 镂空蒙层）
                   • CJFeatureGRView/ScrollViewer - 单图查看器（CJScrollViewer 通用查看器基类 + CJImageScrollViewer 图片查看器；只读缩放/滚动 + 双击放大/单击/长按/下拉关闭，零 CJGRKit 依赖）

                   依赖 CJGRKit 的原子手势/几何能力（GR、KeepCoveredBounds、Geometry/SubHelper）。
                   DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJFeatureGRView_0.1.0" }

  s.frameworks = "UIKit"

  s.requires_arc = true

  # CJImageAdjustGRView.h 图片调整（缩放、拖动）视图：内容第一公民 + 内置手势 + 裁剪窗口约束，无蒙层
  s.subspec 'ImageAdjustGRView' do |ss|
    ss.source_files = "CJFeatureGRView/ImageAdjustGRView/**/*.{h,m}"
    ss.dependency "CJGRKit/AnyGR"               # 内置拖动/捏合手势
    ss.dependency "CJGRKit/KeepBounds/KeepCoveredBounds" # 内置裁剪窗口约束
    ss.dependency "CJGRKit/Geometry/SubHelper"            # 裁剪窗口/内容等比 frame 计算
  end

  # CJMaskImageAdjustGRView.h 图片裁剪编辑完整组件（继承 ImageAdjustGRView 基类 + 镂空蒙层）
  s.subspec 'MaskImageAdjustGRView' do |ss|
    ss.source_files = "CJFeatureGRView/MaskImageAdjustGRView/**/*.{h,m}"
    ss.dependency "CJFeatureGRView/ImageAdjustGRView" # 基类（已带出 GR/KeepCoveredBounds/Geometry/SubHelper）
    ss.dependency 'UIPathCJHelper'                    # 镂空路径绘制
  end

  # CJScrollViewer（通用查看器滚动容器基类）+ CJImageScrollViewer（图片查看器）
  # 零 CJGRKit 依赖：缩放/滚动/居中由 UIScrollView 原生提供，仅含双击/单击/长按/下拉关闭回调
  s.subspec 'ScrollViewer' do |ss|
    ss.source_files = "CJFeatureGRView/ScrollViewer/**/*.{h,m}"
  end

end
