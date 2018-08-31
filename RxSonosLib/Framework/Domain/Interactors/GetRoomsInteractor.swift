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

class GetRoomsValues: RequestValues { }

class GetRoomsInteractor: Interactor {
    
    private let ssdpRepository: SSDPRepository
    private let roomRepository: RoomRepository
    
    init(ssdpRepository: SSDPRepository, roomRepository: RoomRepository) {
        self.ssdpRepository = ssdpRepository
        self.roomRepository = roomRepository
        
        SSDPSettings.shared.maxBufferTime = SonosSettings.shared.searchNetworkForDevices
    }
    
    func buildInteractorObservable(requestValues: GetRoomsValues?) -> Observable<[Room]> {
        
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
                    .do(onNext: { (responses) in
                        CacheManager.shared.set(object: responses.map({ $0.data }), for: CacheKey.ssdpCacheKey.rawValue)
                    })
                    .subscribe(observer)
                
                return Disposables.create([ssdpDisposable])
            })
        }
    }
    
    /* Rooms */
    private func mapDevicesToSonosRooms() -> (([SSDPResponse]) throws -> Observable<[Room]>) {
        return { ssdpDevices in
            let collection = ssdpDevices.compactMap(self.mapSSDPToSonosRoom())
            return Single.zip(collection).asObservable()
        }
    }
    
    private func mapSSDPToSonosRoom() -> ((SSDPResponse) -> Single<Room>?) {
        return { response in
            guard let device = SSDPDevice.map(response) else { return nil }
            return self.roomRepository.getRoom(device: device)
        }
    }
}
