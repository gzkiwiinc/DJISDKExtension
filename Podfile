platform :ios, '9.0'
inhibit_all_warnings!

target 'DJISDKExtension' do
  use_frameworks!

  pod 'DJI-SDK-iOS', '~> 4.8'
  pod 'PromiseKit', '~> 6.4'
  
  target 'DJISDKExtensionTests' do
      inherit! :search_paths
      pod 'DJI-SDK-iOS', '~> 4.8'
      pod 'PromiseKit', '~> 6.4'
  end

end

target 'DJIExtensionDemo' do
  use_frameworks!
  
  pod 'SVProgressHUD'
  pod 'DJI-SDK-iOS', '~> 4.8'
  pod 'PromiseKit', '~> 6.4'
  
end
