//
//  FakeContentDirectoryRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSwift

class FakeContentDirectoryRepositoryImpl: ContentDirectoryRepository {
    
    func getQueue(for room: Room) -> Observable<[Track]> {
        
        let track1 = SpotifyTrack(queueItem: 1, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")!, title: "Before I Die", artist: "Papa Roach", album: "The Connection")
        let track2 = SpotifyTrack(queueItem: 2, duration: 197, uri: "x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")!, title: "Christ Copyright", artist: "Nothing More", album: "Nothing More")
        
        return Observable.just([track1, track2])
    }
    
}
