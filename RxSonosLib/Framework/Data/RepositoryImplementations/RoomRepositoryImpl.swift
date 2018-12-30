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

        if let cache = CacheManager.shared.get(for: device.usn) {
            return Single.just(cache)
                .map(self.mapDataToRoom(device: device))
        }
        
        let locationUrl = device.ip.appendingPathComponent(device.location)
        return network
            .request(download: locationUrl)
            .do(onSuccess: { (data) in
                CacheManager.shared.set(data, for: device.usn)
            })
            .map(self.mapDataToRoom(device: device))
    }
    
}

fileprivate extension RoomRepositoryImpl {
    fileprivate func mapDataToRoom(device: SSDPDevice) -> ((Data) throws -> Room) {
        return { data in
            guard let xml = AEXMLDocument.create(data),
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
