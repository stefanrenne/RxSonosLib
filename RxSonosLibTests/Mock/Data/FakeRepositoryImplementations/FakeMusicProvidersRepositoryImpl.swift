//
//  FakeMusicProvidersRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/05/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxSonosLib

class FakeMusicProvidersRepositoryImpl: MusicProvidersRepository {
    
    var getMusicProvidersCount = 0
    
    func getMusicProviders(for room: Room) -> Observable<[MusicProvider]> {
        
        getMusicProvidersCount += 1
        
        var services = [MusicProvider]()
        
        services.append(MusicProvider(id: 270, name: "Relisten", uri: URL(string: "https://sonos.relisten.net/mp3")!, type: .soundLab, policy: .anonymous, map: Presentation(uri: URL(string: "https://sonos.relisten.net/static/presentationmap.xml")!, version: 1), strings: Presentation(uri: URL(string: "https://sonos.relisten.net/static/strings.xml")!, version: 1)))
        
        services.append(MusicProvider(id: 262, name: "My Cloud Home", uri: URL(string: "https://sonos.mycloud.com/MusicProvider")!, type: .musicService, policy: .appLink, map: Presentation(uri: URL(string: "https://sonos.mycloud.com/static/presentationmap.xml")!, version: 3), strings: Presentation(uri: URL(string: "https://sonos.mycloud.com/static/strings.xml")!, version: 3)))
        
        services.append(MusicProvider(id: 212, name: "Plex", uri: URL(string: "https://sonos.plex.tv/v2/soap")!, type: .soundLab, policy: .appLink, map: Presentation(uri: URL(string: "https://sonos.plex.tv/v2/plex.20180108.xml")!, version: 3), strings: Presentation(uri: URL(string: "https://sonos.plex.tv/v2/plexstrings.20180116.xml")!, version: 3)))
        
        services.append(MusicProvider(id: 9, name: "Spotify", uri: URL(string: "https://spotify-v4.ws.sonos.com/smapi")!, type: .musicService, policy: .appLink, map: Presentation(uri: URL(string: "http://sonos-pmap.ws.sonos.com/spotify_pmap.18.xml")!, version: 22), strings: Presentation(uri: URL(string: "http://spotify.cdn.sonos-ws-us.com/strings.24.xml")!, version: 25)))
        
        return Observable.just(services)
    }
    
}
