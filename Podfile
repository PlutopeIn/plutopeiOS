# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://cdn.cocoapods.org/'
source 'https://github.com/SumSubstance/Specs.git'
target 'Plutope' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Plutope
  #Designing pods
  pod 'SwiftLint','~> 0.52.0'
  pod 'IQKeyboardManagerSwift'
  pod 'SDWebImage'
  
  #Development Pods
#  pod 'TrustWalletCore'
  pod 'CryptoSwift', '~> 1.7.1'
  pod 'DGNetworkingServices'
  pod 'QRScanner'
  pod 'Charts'
  pod 'lottie-ios'
  pod 'ABSteppedProgressBar'
  pod 'SSPlaceHolderTableView'
  pod 'ShapeQRCode'
  pod 'ActiveLabel', '~> 1.1.0'
  pod 'MaterialShowcase'
  pod 'MaterialShowcase'
  pod 'Firebase'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Analytics'
#  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
#  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '8.18.0'
  pod 'CoinbaseWalletSDK'
  pod 'PhoneNumberKit'
  pod 'Mixpanel-swift'
#  pod 'AppsFlyerFramework'
  pod 'DropDown'
#  pod 'OndatoSDK'
  pod 'SVPinView', '~> 1.0'
  pod 'ZendeskSDKMessaging'
#   for SumSub KYC
pod 'IdensicMobileSDK'

  
  # Pods for TronWebDemo
#  pod 'SnapKit', '~> 5.6.0'
# # pod 'TronWeb', '~> 1.1.7'
#pod 'TronWeb', :git => 'https://github.com/james19870606/TronWeb.git', :branch => '1.1.7'
  target 'PlutopeTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'PlutopeUITests' do
    # Pods for testing
  end
  
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
