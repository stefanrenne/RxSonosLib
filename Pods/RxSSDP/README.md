# RxSSDP

[![Swift 4.1](https://img.shields.io/badge/swift-4.1-orange.svg?style=flat)](https://swift.org)
[![Version](https://img.shields.io/cocoapods/v/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)
[![License](https://img.shields.io/cocoapods/l/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)
[![Platform](https://img.shields.io/cocoapods/p/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)

An Reactive SSDP client with buffering written in Swift, based on [SwiftSSDPClient](https://github.com/mhmiles/SwiftSSDPClient)

## How to

1) Implement the repository

```
let repository: SSDPRepository = SSDPRepositoryImpl()
```

2) Scan the network

```
repository.scan(broadcastAddress: "255.255.255.255", searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1", maxTimeSpan: 3, maxCount: 100)
```

3) Subscribe for changes

## Cocoapods

```
pod 'RxSSDP', '~> 4.0'
```


## Testing

1) Create a `FakeSSDPRepository` which returns `SSDPResponse`
