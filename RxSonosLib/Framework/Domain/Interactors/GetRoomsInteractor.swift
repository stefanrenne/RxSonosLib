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
            .flatMap(searchNetworkForDevices)
            .distinctUntilChanged({ $0.count == $1.count })
            .flatMap(mapDevicesToSonosRooms)
    }
    
    /* SSDP */
    private func searchNetworkForDevices(timer: Int) -> Observable<[SSDPResponse]> {
        return Observable<[SSDPResponse]>.create({ (observer) -> Disposable in
            
            let cachedResponses: [SSDPResponse]? = CacheManager.shared.getObject(for: CacheKey.ssdp)
            if let responses: [SSDPResponse] = cachedResponses {
                observer.onNext(responses)
            }
            
            let ssdpDisposable = self
                .ssdpRepository
                .scan(searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1")
                .subscribe(onSuccess: { (response) in
                    guard cachedResponses != response else { return }
                    try? CacheManager.shared.set(object: response, for: CacheKey.ssdp)
                    observer.onNext(response)
                })
            
            return Disposables.create([ssdpDisposable])
        })
    }
    
    /* Rooms */
    private func mapDevicesToSonosRooms(ssdpDevices: [SSDPResponse]) throws -> Observable<[Room]> {
        let collection = try ssdpDevices.compactMap(mapSSDPToSonosRoom)
        return Single.zip(collection).asObservable()
    }
    
    private func mapSSDPToSonosRoom(response: SSDPResponse) throws -> Single<Room>? {
        guard let device = try SSDPDevice.map(response) else { return nil }
        return roomRepository.getRoom(device: device)
    }
}
