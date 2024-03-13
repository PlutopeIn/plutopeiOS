# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Plutope' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Plutope
  #Designing pods
  pod 'SwiftLint'
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
  pod 'Firebase/CoreOnly'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '8.18.0'
  pod 'SDWebImage', '~> 5.0'
#  pod 'Web3Modal', '~> 1.0'
  pod 'CoinbaseWalletSDK'
  pod 'Mixpanel-swift'
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
