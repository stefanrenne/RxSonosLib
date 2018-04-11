//
//  TransportRepositoryImpl.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol TransportRepository {
    
    func getNowPlaying(for room: Room) -> Observable<Track?>
    
    func getNowPlayingProgress(for room: Room) -> Observable<GroupProgress>
    
    func getTransportState(for room: Room) -> Observable<TransportState>
    
    func getImage(for track: Track) -> Observable<Data?>
    
}
