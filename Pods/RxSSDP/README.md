# RxSSDP
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
