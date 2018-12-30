# RxSSDP

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://swift.org)
[![Version](https://img.shields.io/cocoapods/v/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)
[![License](https://img.shields.io/cocoapods/l/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)
[![Platform](https://img.shields.io/cocoapods/p/RxSSDP.svg?style=flat)](http://cocoapods.org/pods/RxSSDP)

A clean reactive SSDP client, based on [UDPBroadcastConnection](https://github.com/gunterhager/UDPBroadcastConnection)

## Usage

1) Implement the repository

```
let repository: SSDPRepository = SSDPRepositoryImpl()
```

2) Scan the network

```
repository.scan(searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1")
```

3) Subscribe for changes


## Modify settings
    
Inspect [SSDPSettings.swift](RxSSDP/SSDPSettings.swift), this class contains all customizable settings.

## Cocoapods

```
pod 'RxSSDP', '~> 4.2'
```


## Testing

1) Create a `FakeSSDPRepository` which returns `SSDPResponse`
