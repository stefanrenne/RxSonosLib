//
//  MusicService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public enum MusicService {
    case Spotify, TuneIn, TV, Unknown
    
    public var isStreamService: Bool {
        switch self {
        case .TuneIn, .TV:
            return true
        default:
            return false
        }
    }
}

extension MusicService {
    
    static func map(string: String?) -> MusicService {
        switch string {
        case "x-sonos-spotify"?:
            return .Spotify
        case "x-rincon-mp3radio"?, "aac"?:
            return .TuneIn
        case "x-sonos-htastream"?:
            return .TV
        default:
            return .Unknown
        }
    }
}
