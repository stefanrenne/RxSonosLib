//
//  RepositoryInjection.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

open class RepositoryInjection {
    static let shared: RepositoryInjection = RepositoryInjection()
    
    init() {
        CacheManager.shared.deleteAll()
    }
    
    internal var ssdpRepository: SSDPRepository = SSDPRepositoryImpl()
    static public func provideSSDPRepository() -> SSDPRepository {
        return shared.ssdpRepository
    }
    
    internal lazy var roomRepository: RoomRepository = { return RoomRepositoryImpl() }()
    static public func provideRoomRepository() -> RoomRepository {
        return shared.roomRepository
    }
    
    internal lazy var groupRepository: GroupRepository = { return GroupRepositoryImpl() }()
    static public func provideGroupRepository() -> GroupRepository {
        return shared.groupRepository
    }
    
    internal lazy var transportRepository: TransportRepository = { return TransportRepositoryImpl() }()
    static public func provideTransportRepository() -> TransportRepository {
        return shared.transportRepository
    }
    
    internal lazy var contentDirectoryRepository: ContentDirectoryRepository = { return ContentDirectoryRepositoryImpl() }()
    static public func provideContentDirectoryRepository() -> ContentDirectoryRepository {
        return shared.contentDirectoryRepository
    }
    
}
