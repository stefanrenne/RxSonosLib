//
//  MusicService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public enum MusicService {
    case musicProvider(sid: Int, flags: Int?, sn: Int?)
    case tv
    case unknown
}

extension MusicService {
    public var isStreamingService: Bool {
        switch self {
        case .tv:
            return true
        default:
            return false
        }
    }
}

extension MusicService: Equatable {
    
    private var rawValue: Int {
        switch self {
        case .musicProvider(let sid, _, _):
            return sid
        case .tv:
            return 9999
        case .unknown:
            return 0
        }
    }
    
    public static func ==(lhs: MusicService, rhs: MusicService) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


extension MusicService {
    
    var sid: Int? {
        switch self {
        case .musicProvider(let sid, _, _):
            return sid
        default:
            return nil
        }
    }
    
    static func map(url: String) -> MusicService {
        
        let urlComponents = URLComponents(string: url)
        if let sid = urlComponents?.queryItems?["sid"]?.int {
            let flags = urlComponents?.queryItems?["flags"]?.int
            let sn = urlComponents?.queryItems?["sn"]?.int
            return MusicService.musicProvider(sid: sid, flags: flags, sn: sn)
        }
        
        let service = url.match(with: "([a-zA-Z0-9-]+):")?.first
        switch service {
        case .some("x-sonos-htastream"):
            return .tv
        default:
            return .unknown
        }
    }
}
