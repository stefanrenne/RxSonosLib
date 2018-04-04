//
//  SonosInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

open class SonosInteractor {
    
    static public func provideGroupsInteractor() -> GetGroupsInteractor {
        return GetGroupsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository(), groupRepository: RepositoryInjection.provideGroupRepository())
    }
    
    static public func provideNowPlayingInteractor() -> GetNowPlayingInteractor {
        return GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
    }
    
    static public func provideTransportStateInteractor() -> GetTransportStateInteractor {
        return GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
    }
    
    static public func provideTrackImageInteractor() -> GetTrackImageInteractor {
        return GetTrackImageInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
    }
    
    static public func provideGroupProgressInteractor() -> GetGroupProgressInteractor {
        return GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
    }
    
    static public func provideGroupQueueInteractor() -> GetGroupQueueInteractor {
        return GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
    }
    
    static public func provideVolumeInteractor() -> GetVolumeInteractor {
        return GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
    }
    
}
