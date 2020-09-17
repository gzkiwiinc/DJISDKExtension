platform :ios, '11.0'
inhibit_all_warnings!

target 'DJISDKExtension' do
  use_frameworks!

  pod 'DJI-SDK-iOS', '~> 4.11.0'
  pod 'PromiseKit'
  
  target 'DJISDKExtensionTests' do
      inherit! :search_paths
      pod 'DJI-SDK-iOS', '~> 4.11.0'
      pod 'PromiseKit'
  end

end

target 'DJIExtensionDemo' do
  use_frameworks!
  
  pod 'SVProgressHUD'
  pod 'DJI-SDK-iOS', '~> 4.11.0'
  pod 'PromiseKit'
  
end
