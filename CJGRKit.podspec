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
  s.version      = "0.2.8"
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
                 • CJGRKit/Geometry/AdjustHelper - CGRectCJAdjustHelper.h 调整移动区域的帮助类（调整 frame 使其包含/保持在界内）
                 • CJGRKit/Geometry/SubHelper - CGRectCJSubHelper.h 按比例取子/父区域的帮助类（常用于裁剪框/内容等比计算）

                 • CJGRKit/KeepBounds/KeepInBounds - UIView+CJKeepInBounds.h 限制本视图不移出其父视图或keyWindow（内方向）
                 • CJGRKit/KeepBounds/KeepCoveredBounds - UIView+CJKeepCoveredBounds.h 给可手势变换的视图叠加外方向 keep-bounds 约束（内容始终覆盖/包含住裁剪窗口，吸附时机由使用方在手势结束时触发）

                 • CJGRKit/AnyGR - UIView+CJAnyGR.h 给任意UIView添加独立的拖动、捏合缩放、旋转手势
                 • CJGRKit/CornerGR - UIView+CJCornerGR.h 给任意UIView添加角按钮编辑层（依赖 AnyGR 复用 scale/rotation 状态）
                 • CJGRKit/FreeDrag - UIView+CJFreeDrag.h 通过pan手势，任意方向自由拖动的视图
                 • CJGRKit/PanDown - UIView+CJPanDown.h 下拉回弹的视图拖动

                 每个子库可独立引入，详见各子库描述。
                 DESC
  

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJGRKit.git", :tag => "CJGRKit_0.2.8" }
  #s.source_files  = "CJDemoCommon/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # Geometry 几何核心层：纯 CGRect 几何计算（被 KeepBounds 等上层能力依赖）
  s.subspec 'Geometry' do |ss|
    # CGRectCJAdjustHelper.h 调整移动区域的帮助类（调整 frame 使其包含/保持在界内）
    ss.subspec 'AdjustHelper' do |adjustHelper|
      adjustHelper.source_files = "CJGRKit/Geometry/AdjustHelper/*.{h,m}"
    end

    # CGRectCJSubHelper.h 按比例取子/父区域帮助类（常用于裁剪框/内容等比计算）
    ss.subspec 'SubHelper' do |subHelper|
      subHelper.source_files = "CJGRKit/Geometry/SubHelper/*.{h,m}"
    end
  end

  # KeepBounds 家族：约束层（内方向 KeepInBounds / 外方向 KeepCoveredBounds），共享 Geometry/AdjustHelper 几何核心
  s.subspec 'KeepBounds' do |ss|
    # UIView+CJKeepInBounds.h 限制本视图不移出其父视图或keyWindow（内方向）
    ss.subspec 'KeepInBounds' do |keepInBounds|
      keepInBounds.source_files = "CJGRKit/KeepBounds/KeepInBounds/*.{h,m}"
      keepInBounds.dependency "CJGRKit/Geometry/AdjustHelper"
    end

    # UIView+CJKeepCoveredBounds.h 给可手势变换的视图叠加外方向 keep-bounds 约束（内容始终覆盖/包含住裁剪窗口，吸附时机由使用方触发）
    ss.subspec 'KeepCoveredBounds' do |keepCoveredBounds|
      keepCoveredBounds.source_files = "CJGRKit/KeepBounds/KeepCoveredBounds/*.{h,m}"
      keepCoveredBounds.dependency "CJGRKit/Geometry/AdjustHelper"  # 复用外方向几何（内容作为大框包含住裁剪窗口）
    end
  end

  # 原子手势层：每种手势能力独立子库，可按需引入
  s.subspec 'AnyGR' do |ss|
    # UIView+CJAnyGR.h 给任意UIView添加独立的拖动、捏合缩放、旋转手势，可按需添加任意组合
    ss.source_files = "CJGRKit/AnyGR/**/*.{h,m}"
  end

  # CornerGR 角按钮编辑层：给任意UIView添加角按钮编辑层（边框、删除、更新、右下缩放旋转柄），依赖 AnyGR 复用 scale/rotation 状态
  s.subspec 'CornerGR' do |ss|
    # UIView+CJCornerGR.h 给任意UIView添加角按钮编辑层（边框、删除、更新、右下缩放旋转柄）
    ss.source_files = "CJGRKit/CornerGR/**/*.{h,m}"
    ss.dependency "CJGRKit/AnyGR"  # 右下操作柄需要复用 AnyGR 的 scale/rotation 状态
  end

  # FreeDrag 自由拖动：通过 pan 手势任意方向自由拖动视图（已废弃，推荐用 AnyGR）
  s.subspec 'FreeDrag' do |ss|
    # 视图拖动 UIView+CJFreeDrag.h-通过给View添加UIPanGestureRecognizer手势，使其可以移动到拖动的位置（任意方向自由拖动）
    ss.source_files = "CJGRKit/FreeDrag/**/*.{h,m}"
  end
  
  # PanDown 下拉回弹：通过 pan 手势下拉视图，松手后回弹到原位
  s.subspec 'PanDown' do |ss|
    # UIView+CJPanDown.h 下拉回弹的视图拖动
    ss.source_files = "CJGRKit/PanDown/**/*.{h,m}"
  end

  
end
