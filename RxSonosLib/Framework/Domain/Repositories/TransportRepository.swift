//
//  TransportRepositoryImpl.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol TransportRepository {
    
    func getNowPlaying(for room: Room) -> Single<Track?>
    
    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress>
    
    func getTransportState(for room: Room) -> Single<TransportState>
    
    func getImage(for track: Track) -> Maybe<Data>
    
    func setNextTrack(for room: Room) -> Completable
    
    func setPreviousTrack(for room: Room) -> Completable
    
}
