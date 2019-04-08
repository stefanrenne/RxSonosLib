# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'RxSonosLib' do
  platform :ios, '10.0'
  
  pod 'RxSwift', '~> 4.5'
  pod 'RxSSDP', '~> 5.0'
  pod 'AEXML', '~> 4.4'
  pod 'SwiftLint'

  target 'RxSonosLibTests' do
    inherit! :search_paths

    pod 'Mockingjay'
    pod 'RxBlocking', '~> 4.5'
  end

end

target 'iOS Demo App' do
  platform :ios, '10.0'

  pod 'RxSonosLib', :path => '.'
  pod 'RxSwift', '~> 4.5'
  pod 'RxCocoa', '~> 4.5'
end

# Disable Code Coverage for Pods projects
# Disable Dsym Generation in Mock Config for faster test build
post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    if ["Mockingjay", "URITemplate"].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = "4.2"
      end
    end
  end
end