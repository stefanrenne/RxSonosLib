//
//  TransportState.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


public enum TransportState: Int {
    case Transitioning, Playing, Paused, Stopped
}

extension TransportState {
    
    static func map(string: String?) -> TransportState {
        switch string {
        case "TRANSITIONING"?:
            return .Transitioning
        case "PLAYING"?:
            return .Playing
        case "PAUSED_PLAYBACK"?:
            return .Paused
        default:
            return .Stopped
        }
    }
}
