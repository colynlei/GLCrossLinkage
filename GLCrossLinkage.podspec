#
#  Be sure to run `pod spec lint GLCrossLinkage.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "GLCrossLinkage"
  s.version      = "1.0.0"
  s.summary      = "类似于美团外卖、饿了么商家页面效果"
  s.homepage     = "https://github.com/colynlei/GLSegmentedControl"
  s.license      = "MIT"
  s.author       = { "『国』" => "leiguolin@huobi.com" }
  s.source       = { :git => "https://github.com/colynlei/GLCrossLinkage.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "GLCrossLinkage/GLCrossLinkageView/*.{h,m}"
  s.ios.deployment_target = "9.0"
  s.requires_arc = true



end
