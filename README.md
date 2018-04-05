# RxSonosLib
[![Swift 4.1](https://img.shields.io/badge/swift-4.1-orange.svg?style=flat)](https://swift.org)
[![Travis Badge](https://api.travis-ci.org/stefanrenne/RxSonosLib.svg?branch=master)](https://travis-ci.org/stefanrenne/RxSonosLib)
[![Test Coverage](https://api.codeclimate.com/v1/badges/445e34c7de447fb011ec/test_coverage)](https://codeclimate.com/github/stefanrenne/RxSonosLib/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/445e34c7de447fb011ec/maintainability)](https://codeclimate.com/github/stefanrenne/RxSonosLib/maintainability)
[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/RxSonosLib.svg)](https://cocoapods.org/pods/RxSonosLib)
[![License Badge](https://img.shields.io/cocoapods/l/RxSonosLib.svg)](LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/RxSonosLib.svg?style=flat)](http://cocoapods.org/pods/RxSonosLib)


Swift library that simplifies interacting with Sonos Devices

Features:

- [x] GET SSDP devices on the current network
- [x] MAP SSDP devices into Sonos Rooms
- [x] MAP Sonos Rooms into Sonos Groups + renew
- [x] GET now playing track per room (supports Spotify, Tunein & TV) + renew
- [x] DOWNLOAD track image
- [x] GET group progress + renew
- [x] GET group queue
- [ ] ADD tracks to the group queue
- [ ] DELETE tracks from the group queue
- [ ] SET previous/next group queue track
- [ ] SET play/pause/stop current track
- [x] GET group volume
- [x] SET group volume

Platform:

- [x] iOS
- [x] MacOS
- [x] tvOS


This library requires Swift 4.1 & RxSwift.

## Background Info
The first version of this project started as a way to understand Sonos better. This version is here to help me improve my RxSwift knowledge.

## Usage

Get the required interactor and subscribe for changes, example:

```
SonosInteractor
.provideGroupsInteractor()
.get()
.subscribe(onNext: { (groups) in
	print("groups: onNext")
}, onError: { (error) in
	print("groups: \(error.localizedDescription)")
}, onCompleted: {
	print("groups: onCompleted")
}).disposed(by: disposeBag)
```

## All Interactors

### 1) Find all Sonos groups


```
let interactor: GetGroupsInteractor = SonosInteractor
	.provideGroupsInteractor()
	.get()
```

### 2) Get the current track for a Sonos group

```
let interactor: GetNowPlayingInteractor
	.provideNowPlayingInteractor()
   .get(values: GetNowPlayingValues(group: <#T##Group#>))
```

### 3) Get the current state for a Sonos group (playing, paused, stopped, etc)

```
let interactor: GetTransportStateInteractor = SonosInteractor
	.provideTransportStateInteractor()
	.get(values: GetTransportStateValues(group: <#T##Group#>))
```

### 4) Get the progressed time for a Sonos Group

```
let interactor: GetGroupProgressInteractor = SonosInteractor
	.provideGroupProgressInteractor()
	.get(values: GetGroupProgressValues(track: <#T##Group#>))
```

### 5) Get the queue for a Sonos Group

```
let interactor: GetGroupQueueInteractor = SonosInteractor
	.provideGroupQueueInteractor()
	.get(values: GetGroupQueueValues(group: <#T##Group#>))
```

### 6) Get the image for a Sonos Track

```
let interactor: GetTrackImageInteractor = SonosInteractor
	.provideTrackImageInteractor()
	.get(values: GetTrackImageValues(track: <#T##Track#>))
```
    
### More demos?

Clone the repository, open `RxSonosLib.xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
