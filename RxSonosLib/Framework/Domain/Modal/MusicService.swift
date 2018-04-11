//
//  MusicService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public enum MusicService {
    case spotify, tunein, tv, unknown
}

extension MusicService {
    
    static func map(string: String?) -> MusicService {
        switch string {
        case "x-sonos-spotify"?:
            return .spotify
        case "x-rincon-mp3radio"?, "aac"?:
            return .tunein
        case "x-sonos-htastream"?:
            return .tv
        default:
            return .unknown
        }
    }
    
    public var isStreamingService: Bool {
        switch self {
        case .tunein, .tv:
            return true
        default:
            return false
        }
    }
}
