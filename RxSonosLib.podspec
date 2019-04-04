Pod::Spec.new do |spec|
  spec.name                   = 'RxSonosLib'
  spec.version                = '0.14.0'
  spec.license                = { :type => 'Apache-2.0' }
  spec.homepage               = 'https://github.com/stefanrenne/RxSonosLib'
  spec.authors                = { 'Stefan Renne' => 'info@stefanrenne.nl' }
  spec.summary                = 'RxSwift library that simplifies interacting with Sonos Devices'
  spec.source                 = { :git => 'https://github.com/stefanrenne/RxSonosLib.git', :tag => spec.version.to_s }
  spec.swift_version          = '5.0'
  spec.ios.deployment_target  = '10.0'
  spec.tvos.deployment_target = '10.0'
  spec.osx.deployment_target  = '10.12'
  spec.watchos.deployment_target = '4.0'
  spec.requires_arc           = true
  spec.source_files           = 'RxSonosLib/Framework/**/*.swift'
  spec.dependency             'RxSwift', '~> 4.5'
  spec.dependency             'RxSSDP', '~> 5.0'
  spec.dependency             'AEXML', '~> 4.4'
end
