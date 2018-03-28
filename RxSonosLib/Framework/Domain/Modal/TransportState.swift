//
//  TransportState.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


public enum TransportState: Int {
    case transitioning, playing, paused, stopped
}

extension TransportState {
    
    static func map(string: String?) -> TransportState {
        switch string {
        case "TRANSITIONING"?:
            return .transitioning
        case "PLAYING"?:
            return .playing
        case "PAUSED_PLAYBACK"?:
            return .paused
        default:
            return .stopped
        }
    }
}
