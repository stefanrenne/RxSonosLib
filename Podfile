# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'RxSonosLib' do
  use_frameworks!

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
  use_frameworks!
  pod 'RxSonosLib', :path => '.'
  pod 'RxSwift', '~> 4.5'
  pod 'RxCocoa', '~> 4.5'
end
