# Uncomment this line to define a global platform for your project

target 'trackto' do
    platform :ios, '8.4'
    use_frameworks!
    pod 'KeychainAccess', :git => 'https://github.com/kishikawakatsumi/KeychainAccess.git', :branch => 'swift-2.0'
    pod 'MBProgressHUD', '~> 0.9.1'
    pod 'SwiftOverlays', '~> 0.14'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'MGSwipeTableCell'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.to_s.include? 'Pods'
            target.build_configurations.each do |config|
                if !config.to_s.include? 'Debug'
                    config.build_settings['CODE_SIGN_IDENTITY[sdk=iphoneos*]'] = 'iPhone Distribution'
                end
            end
        end
    end
end