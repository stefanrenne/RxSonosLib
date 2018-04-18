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
- [x] SET previous/next group queue track
- [x] SET play/pause/stop current track
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

Inspect [SonosInteractor.swift](RxSonosLib/Framework/Domain/Interactors/SonosInteractor.swift) this class is your entry to the library.

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

### SonosInteractor Observers

**Groups**

- `static func getAllGroups() -> Observable<[Group]>`

**Active group**

- `static func setActive(group: Group)`
- `static func getActiveGroup() -> Observable<Group?> `
- `static func getActiveTrack() -> Observable<Track?>`
- `static func getActiveTransportState() -> Observable<(TransportState, MusicService)>`  
- `static func setActiveTransport(state: TransportState) -> Observable<Void>`
- `static func getActiveTrackImage() -> Observable<Data?>`  
- `static func getActiveGroupProgress() -> Observable<GroupProgress>`  
- `static func getActiveGroupQueue() -> Observable<[Track]>`      
- `static func getActiveGroupVolume() -> Observable<Int>`  
- `static func setActiveGroup(volume: Int) -> Observable<Void>`
- `static func setActiveNextTrack() -> Observable<Void>`
- `static func setActivePreviousTrack() -> Observable<Void>`

**Group specific functions**

- `static func getTrack(_ group: Group) -> Observable<Track?>`
- `static func getTransportState(_ group: Group) -> Observable<TransportState>`
- `static func setTransport(state: TransportState, for group: Group) -> Observable<Void>`
- `static func getVolume(_ group: Group) -> Observable<Int>`
- `static func set(volume: Int, for group: Group) -> Observable<Void>`
- `static func setNextTrack(_ group: Group) -> Observable<Void>`
- `static func setPreviousTrack(_ group: Group) -> Observable<Void>`

**Track specific functions**

- `static func getTrackImage(_ track: Track) -> Observable<Data?>`

### Group object Observers

- `func getTrack() -> Observable<Track?>`
- `func getTransportState() -> Observable<(TransportState, MusicService)> `
- `func set(state: TransportState) -> Observable<Void>`
- `func getVolume() -> Observable<Int>`
- `func set(volume: Int) -> Observable<Void>`
- `func setNextTrack() -> Observable<Void>`
- `func setPreviousTrack() -> Observable<Void>`

### Track object Observers

- `func getImage() -> Observable<Data?>`

### Modify settings
    
Inspect [SonosSettings.swift](RxSonosLib/Framework/Common/SonosSettings.swift), this class contains all customizable settings.
    
#### More demos?

Clone the repository, open `RxSonosLib.xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
