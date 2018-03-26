# RxSonosLib
[![Travis Badge](https://api.travis-ci.org/stefanrenne/RxSonosLib.svg?branch=master)](https://travis-ci.org/stefanrenne/RxSonosLib)
<!--[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/RxSonosLib.svg)](https://cocoapods.org/pods/RxSonosLib)
![Supported Platforms Badge](https://img.shields.io/cocoapods/p/RxSonosLib.svg)
[![Percentage Documented Badge](https://img.shields.io/cocoapods/metrics/doc-percent/RxSonosLib.svg)](http://cocoadocs.org/docsets/RxSonosLib)
[![License Badge](https://img.shields.io/cocoapods/l/RxSonosLib.svg)](LICENSE)-->

Swift library that simplifies interacting with Sonos Devices

Todo:

- [x] Find Sonos devices on the current network
- [x] map SSDP devices into Sonos Rooms
- [x] map Sonos Rooms into Sonos Groups
- [x] automatically scan for group changes every 5 seconds
- [ ] see what track is currently playing
- [ ] play/pause/stop current track
- [ ] see what what tracks are in the queue
- [ ] previous/next queue track
- [ ] remove tracks from queue


This library requires Swift 4 & RxSwift.

## Background Info
The first version of this project started as a way to understand Sonos better. This version is here to help me improve my RxSwift knowledge.

## Usage

### 1) Find all Sonos groups

Get the Sonos Groups interactor


```
let getGroupsInteractor: GetGroupsInteractor = SonosInteractor.provideGroupsInteractor()
```

Get the Observable<[Group]> object

```
let observableGroups = getGroupsInteractor.get()
```

	
Subscribe for changes

```
observableGroups.subscribe(onNext: { (groups) in
	print("groups: onNext")
}, onError: { (error) in
	print("groups: \(error.localizedDescription)")
}, onCompleted: {
	print("groups: onCompleted")
}).disposed(by: disposeBag)
```

    
### More demos?

Clone the repository, open `RxSonosLib.xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## Cocoapods

When v1.0 is released

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
