# RxSonosLib
[![Swift 4.2](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://swift.org)
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
- [x] GET now playing track per room (supports Spotify, Tunein, Library & TV) + renew
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


This library requires Swift 4.2 & RxSwift.

## Background Info
The first version of this project started as a way to understand Sonos better. This version is here to help me improve my RxSwift knowledge.

## Usage

Inspect [SonosInteractor.swift](RxSonosLib/Framework/Domain/Interactors/SonosInteractor.swift) this class is your entry to the library.

From here, continue by chaining observerable functions specified in the matching models [Group.swift](RxSonosLib/Framework/Domain/Modal/Group.swift), [Room.swift](RxSonosLib/Framework/Domain/Modal/Room.swift) & [Track.swift](RxSonosLib/Framework/Domain/Modal/Track.swift)

Example:

```
SonosInteractor
.getActiveGroup()
.getQueue()
.subscribe(onNext: { (queue) in
	print("queue: onNext")
}, onError: { (error) in
	print("queue: \(error.localizedDescription)")
}, onCompleted: {
	print("queue: onCompleted")
}).disposed(by: disposeBag)
```

### Framework entry point

Start with a static function in the SonosInteractor

```
open class SonosInteractor {

   static func setActive(group: Group)

   static func getActiveGroup() -> Observable<Group>

	static func getAllGroups() -> Observable<[Group]>
}
```

### Observable chain methods

The continue with one or multiple chain methods.

**Methods for an Observable Group:**

```
extension ObservableType where E == Group {

    func getRooms() -> Observable<[Room]>

    func getTrack() -> Observable<Track?>

    func getImage() -> Observable<Data?>

    func getProgress() -> Observable<GroupProgress>

    func getQueue() -> Observable<[Track]>

    func getTransportState() -> Observable<(TransportState, MusicService)>

    func set(transportState: TransportState) -> Observable<TransportState>

    func getVolume() -> Observable<Int>

    func set(volume: Int) -> Observable<Int>

    func setNextTrack() -> Observable<Swift.Void>

    func setPreviousTrack() -> Observable<Swift.Void>

    func getMute() -> Observable<[Bool]>

    func set(mute enabled: Bool) -> Observable<[Bool]>
}
```

**Methods for an Observable Track:**

```
extension ObservableType where E == Track {

    func getImage() -> Observable<Data?>
}
```

**Methods for an Observable array with Room's:**

```
extension ObservableType where E == [Room] {

    func getMute() -> Observable<[Bool]>

    func set(mute enabled: Bool) -> Observable<[Bool]>
}

```

**Methods for an Observable Room:**

```
extension ObservableType where E == Room {

    func getMute() -> Observable<Bool>

    func set(mute enabled: Bool) -> Observable<Bool>
}
```


### Modify settings
    
Inspect [SonosSettings.swift](RxSonosLib/Framework/Common/SonosSettings.swift), this class contains all customizable settings.
    
#### More demos?

Clone the repository, open `xcworkspace` and build the demo project

## Development Info
Please document code changes in unit tests and make sure all tests are green.

## License
This project is released under the [Apache-2.0 license](LICENSE.txt).
