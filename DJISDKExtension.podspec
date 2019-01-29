#
#  Be sure to run `pod spec lint DJISDKExtension.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "DJISDKExtension"
  s.version      = "0.4.0"
  s.summary      = "Extension for DJISDK-iOS."
  s.description  = "Extension for DJISDK-iOS, only support Swift."
  s.homepage     = "https://github.com/gzkiwiinc/DJISDKExtension"
  s.license      = "MIT"
  s.authors      = { "Kyle" => "lacklock@gmail.com",
                     "Pandara" => "wen.pandara@gmail.com" }
  s.swift_version = "4.2"
  s.ios.deployment_target = "9.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/gzkiwiinc/DJISDKExtension.git", :tag => "#{s.version}" }
  s.source_files  = "DJISDKExtension/*.swift", "DJISDKExtension/**/*.swift"


  s.dependency "DJI-SDK-iOS", "~> 4.8"
  s.dependency "PromiseKit", "~> 6.4"

  s.pod_target_xcconfig = {'ENABLE_BITCODE' => 'NO'} # due to dji sdk
end
