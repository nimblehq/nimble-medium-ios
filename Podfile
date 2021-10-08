# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NimbleMedium' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for NimbleMedium
  pod 'AlamofireNetworkActivityLogger'
  pod 'Firebase/Crashlytics'
  pod 'R.swift'
  pod 'RxAlamofire'
  pod 'RxCocoa'
  pod 'RxCombine'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxSwift'
  pod 'SwiftLint'
  pod 'Wormholy'

  target 'NimbleMediumTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble'
    pod 'Quick'
    pod 'RxNimble', subspecs: ['RxBlocking', 'RxTest']
    pod 'RxSwift'
    pod 'Sourcery'
  end

  target 'NimbleMediumUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
