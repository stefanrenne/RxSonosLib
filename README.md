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

Inspect `SonosInteractor` this class is your entry to the library.
The models `Group` & `Track` also contains functions to generate new Observables.

Example:

```
SonosInteractor
.getAllGroups()
.subscribe(onNext: { (groups) in
	print("groups: onNext")
}, onError: { (error) in
	print("groups: \(error.localizedDescription)")
}, onCompleted: {
	print("groups: onCompleted")
}).disposed(by: disposeBag)
```

### SonosInteractor: All Observers

**Groups**

- `static public func getAllGroups() -> Observable<[Group]>`

**Active group**

- `static public func getActiveGroup() -> Observable<Group?> `
- `static public func getActiveTrack() -> Observable<Track?>`
- `static public func getActiveTransportState() -> Observable<TransportState>`  
- `static public func getActiveTrackImage() -> Observable<Data?>`  
- `static public func getActiveGroupProgress() -> Observable<GroupProgress>`  
- `static public func getActiveGroupQueue() -> Observable<[Track]>`      
- `static public func getActiveGroupVolume() -> Observable<Int>`  
- `static public func setActiveGroup(volume: Int) -> Observable<Void>`

**Group specific functions**

- `static public func getTrack(_ group: Group) -> Observable<Track>`
- `static public func getTransportState(_ group: Group) -> Observable<TransportState>`

**Track specific functions**

- `static public func getTrackImage(_ track: Track) -> Observable<Data?>`

### Group: All Observers

- `func getTrack() -> Observable<Track>`

### Track: All Observers

- `func getImage() -> Observable<Data?>`
    
#### More demos?

Clone the repository, open `RxSonosLib.xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
