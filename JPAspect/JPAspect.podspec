#
#  Be sure to run `pod spec lint JPAspect.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "JPAspect"
  spec.version      = "1.0.0"
  spec.summary      = "JPAspect fix bugs dynamically by json."
  spec.homepage     = "https://github.com/zhiyongzou/JPAspect"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "zzyong" => "scauzouzhiyong@163.com" }
  spec.source       = { :git => "https://github.com/zhiyongzou/JPAspect.git", :tag => spec.version }
  spec.source_files = "JPAspect/*.{h,m}"
  spec.ios.deployment_target = '6.0'
  spec.requires_arc = true

  spec.subspec 'Base' do |ss|
    ss.source_files = "JPAspect/Base/*.{h,m}"
  end

  spec.subspec 'Model' do |ss|
    ss.source_files = "JPAspect/Model/*.{h,m}"
  end

end
