# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'RxSonosLib' do
  use_frameworks!

  pod 'RxSwift', '~> 4.1'
  pod 'RxCocoa', '~> 4.1'
  pod 'RxSSDP', '~> 4.1'
  pod 'AEXML', '~> 4.2'
  pod 'SwiftLint'

  target 'RxSonosLibTests' do
    inherit! :search_paths
    pod 'Mockingjay', '~> 2.0'
    pod 'RxBlocking', '~> 4.1'
  end

end

target 'Demo App' do
  use_frameworks!
  pod 'RxSwift', '~> 4.1'
  pod 'RxCocoa', '~> 4.1'
end
