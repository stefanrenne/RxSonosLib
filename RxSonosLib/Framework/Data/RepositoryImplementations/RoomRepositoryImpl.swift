//
//  RoomRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class RoomRepositoryImpl: RoomRepository {
    
    private let network = DownloadNetwork()
    
    func getRoom(device: SSDPDevice) -> Single<Room>? {
        guard device.isSonosDevice else { return nil }

        if let cache: Room = CacheManager.shared.getObject(for: .room, item: device.usn) {
            return Single.just(cache)
        }
        
        let locationUrl = device.ip.appendingPathComponent(device.location)
        return network
            .request(download: locationUrl)
            .map(mapDataToRoom(device: device))
            .do(onSuccess: { (room) in
                try? CacheManager.shared.set(object: room, for: .room, item: device.usn)
            })
    }
    
}

private extension RoomRepositoryImpl {
    func mapDataToRoom(device: SSDPDevice) -> ((Data) throws -> Room) {
        return { data in
            guard let xml = try AEXMLDocument.create(data),
                let description = DeviceDescription.map(xml) else {
                    #if DEBUG
                        print(String(data: data, encoding: .utf8)!)
                    #endif
                    throw SonosError.noData
            }
            return Room(ssdpDevice: device, deviceDescription: description)
        }
    }
}
