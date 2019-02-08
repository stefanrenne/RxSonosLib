//
//  Injection.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

class Injection {
    internal static let shared: Injection = Injection()
    
    init() {
        CacheManager.shared.clear()
    }
    
    /* Sonos Injection */
    internal lazy var sonosInteractor: SonosInteractor = { SonosInteractor() }()
    static internal func provideSonosInteractor() -> SonosInteractor {
        return shared.sonosInteractor
    }
    
    /* Repository Injection */
    internal lazy var ssdpRepository: SSDPRepository = { SSDPRepositoryImpl() }()
    static public func provideSSDPRepository() -> SSDPRepository {
        return shared.ssdpRepository
    }
    
    internal lazy var roomRepository: RoomRepository = { RoomRepositoryImpl() }()
    static public func provideRoomRepository() -> RoomRepository {
        return shared.roomRepository
    }
    
    internal lazy var groupRepository: GroupRepository = { GroupRepositoryImpl() }()
    static public func provideGroupRepository() -> GroupRepository {
        return shared.groupRepository
    }
    
    internal lazy var transportRepository: TransportRepository = { TransportRepositoryImpl() }()
    static public func provideTransportRepository() -> TransportRepository {
        return shared.transportRepository
    }
    
    internal lazy var contentDirectoryRepository: ContentDirectoryRepository = { ContentDirectoryRepositoryImpl() }()
    static public func provideContentDirectoryRepository() -> ContentDirectoryRepository {
        return shared.contentDirectoryRepository
    }
    
    internal lazy var renderingControlRepository: RenderingControlRepository = { RenderingControlRepositoryImpl() }()
    static public func provideRenderingControlRepository() -> RenderingControlRepository {
        return shared.renderingControlRepository
    }
    
    internal lazy var alarmRepository: AlarmRepository = { AlarmRepositoryImpl() }()
    static public func provideAlarmRepository() -> AlarmRepository {
        return shared.alarmRepository
    }
    
    internal lazy var musicProvidersRepository: MusicProvidersRepository = { MusicProvidersRepositoryImpl() }()
    static public func provideMusicProvidersRepository() -> MusicProvidersRepository {
        return shared.musicProvidersRepository
    }
    
}
