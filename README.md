# RxSonosLib
[![Travis Badge](https://api.travis-ci.org/stefanrenne/RxSonosLib.svg?branch=master)](https://travis-ci.org/stefanrenne/RxSonosLib)
[![Test Coverage](https://api.codeclimate.com/v1/badges/445e34c7de447fb011ec/test_coverage)](https://codeclimate.com/github/stefanrenne/RxSonosLib/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/445e34c7de447fb011ec/maintainability)](https://codeclimate.com/github/stefanrenne/RxSonosLib/maintainability)
<!--[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/RxSonosLib.svg)](https://cocoapods.org/pods/RxSonosLib)
![Supported Platforms Badge](https://img.shields.io/cocoapods/p/RxSonosLib.svg)
[![Percentage Documented Badge](https://img.shields.io/cocoapods/metrics/doc-percent/RxSonosLib.svg)](http://cocoadocs.org/docsets/RxSonosLib)
[![License Badge](https://img.shields.io/cocoapods/l/RxSonosLib.svg)](LICENSE)-->

Swift library that simplifies interacting with Sonos Devices

Features:

- [x] Find Sonos devices on the current network
- [x] map SSDP devices into Sonos Rooms
- [x] map Sonos Rooms into Sonos Groups
- [x] automatically scan for group changes every 5 seconds
- [x] see what track is currently playing (supports Spotify, Tunein & TV)
- [x] see the image of the current track
- [x] see the progress of the current track
- [ ] play/pause/stop current track
- [ ] see what what tracks are in the queue
- [ ] previous/next queue track
- [ ] remove tracks from queue

Platform:


- [x] support iOS
- [ ] support MacOS
- [ ] support tvOS
- [ ] support Linux


This library requires Swift 4 & RxSwift.

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

### 5) Get the image for a Sonos Track

```
let interactor: GetTrackImageInteractor = SonosInteractor
	.provideTrackImageInteractor()
	.get(values: GetTrackImageValues(track: <#T##Track#>))
```
    
### More demos?

Clone the repository, open `RxSonosLib.xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## Cocoapods

When v1.0 is released

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
