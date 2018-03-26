# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'RxSonosLib' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSSDP', '~> 4.0'
  pod 'AEXML'
  pod 'NetUtils'
  pod 'ReachabilitySwift'

  target 'RxSonosLibTests' do
    inherit! :search_paths
    pod 'Mockingjay'
    pod 'RxBlocking'
  end

end

target 'Demo App' do
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
end
