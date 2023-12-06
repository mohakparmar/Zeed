# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Zeed' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Zeed
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'EZYGradientView', :git => 'https://github.com/Niphery/EZYGradientView'
  pod 'SquareFlowLayout'
  pod 'Parchment'
  pod 'Alamofire'
  pod 'GrowingTextView'
  pod 'GMStepper'
  pod 'MessageKit'
  pod 'JGProgressHUD'
  pod 'Kingfisher'
  pod 'SwipeCellKit'
  pod 'MarqueeLabel'
  pod 'IQKeyboardManagerSwift'
  pod 'ImageScrollView'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'DatePickerDialog'
  pod 'ISMessages'
  pod 'SDWebImage', '~> 4.0'
  pod 'Nuke'
  pod "ReverseExtension"
  pod 'SwiftVideoBackground'
  pod 'GoogleMaps'
  pod 'Firebase/Core'
  pod 'ZendeskSDKMessaging'
  pod 'Adjust'
  pod 'IDMPhotoBrowser'
  pod 'MyFatoorah'

  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end

  target 'ZeedTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'ZeedUITests' do
    # Pods for testing
  end
end
