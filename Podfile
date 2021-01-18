platform :ios, '11.0'
inhibit_all_warnings!

def share_pods
  pod 'DJI-SDK-iOS'
  pod 'PromiseKit'
end

target 'DJISDKExtension' do
  use_frameworks!

  share_pods
  
  target 'DJISDKExtensionTests' do
      inherit! :search_paths
      share_pods
  end

end

target 'DJIExtensionDemo' do
  use_frameworks!
  share_pods
  pod 'SVProgressHUD'
end
