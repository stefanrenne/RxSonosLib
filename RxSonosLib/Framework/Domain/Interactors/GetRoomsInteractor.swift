//
//  GetRoomsInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSSDP

struct GetRoomsValues: RequestValues { }

class GetRoomsInteractor: ObservableInteractor {
    
    typealias T = GetRoomsValues
    
    private let ssdpRepository: SSDPRepository
    private let roomRepository: RoomRepository
    
    init(ssdpRepository: SSDPRepository, roomRepository: RoomRepository) {
        self.ssdpRepository = ssdpRepository
        self.roomRepository = roomRepository
        
        SSDPSettings.shared.maxBufferTime = SonosSettings.shared.searchNetworkForDevices
    }
    
    func buildInteractorObservable(values: GetRoomsValues?) -> Observable<[Room]> {
        
        return
            createTimer(SonosSettings.shared.renewNetworkDevicesTimer)
            .flatMap(searchNetworkForDevices())
            .distinctUntilChanged({ $0.count == $1.count })
            .flatMap(mapDevicesToSonosRooms())
    }
    
    /* SSDP */
    private func searchNetworkForDevices() -> ((Int) -> Observable<[SSDPResponse]>) {
        return { _ in
            return Observable<[SSDPResponse]>.create({ (observer) -> Disposable in
                
                if let responses: [[String: String]] = CacheManager.shared.getObject(for: CacheKey.ssdpCacheKey.rawValue) {
                    observer.onNext(responses.map({ SSDPResponse(data: $0) }))
                }
                
                let ssdpDisposable = self.ssdpRepository.scan(searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1")
                    .subscribe(onSuccess: { (responses) in
                        CacheManager.shared.set(object: responses.map({ $0.data }), for: CacheKey.ssdpCacheKey.rawValue)
                        observer.onNext(responses)
                    })
                
                return Disposables.create([ssdpDisposable])
            })
        }
    }
    
    /* Rooms */
    private func mapDevicesToSonosRooms() -> (([SSDPResponse]) throws -> Observable<[Room]>) {
        return { ssdpDevices in
            let collection = try ssdpDevices.compactMap(self.mapSSDPToSonosRoom())
            return Single.zip(collection).asObservable()
        }
    }
    
    private func mapSSDPToSonosRoom() -> ((SSDPResponse) throws -> Single<Room>?) {
        return { response in
            guard let device = try SSDPDevice.map(response) else { return nil }
            return self.roomRepository.getRoom(device: device)
        }
    }
}
