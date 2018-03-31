//
//  FakeTransportRepositoryImpl.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class FakeTransportRepositoryImpl: TransportRepository {
    
    func getNowPlaying(for room: Room) -> Observable<Track> {
        
        return Observable.just(Track(service: .spotify, queueItem: 7, time: 149, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1"), title: "Before I Die", artist: "Papa Roach", album: "The Connection"))
    }
    
    func getTransportState(for room: Room) -> Observable<TransportState> {
        return Observable.just(TransportState.paused)
    }
    
    func getImage(for track: Track) -> Observable<UIImage?> {
        return Observable.just(UIImage(named: "papa-roach-the-connection.jpg"))
    }
    
}
