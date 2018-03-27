//
//  TransportState.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


public enum TransportState {
    case Transitioning, PausedQueue, PlayingQueue, StoppedStream, PlayingStream
}

extension TransportState {
    
    static func map(string: String?, for service: MusicService) -> TransportState {
        switch string {
        case "TRANSITIONING"?:
            return .Transitioning
        case "PLAYING"?:
            return (service.isStreamService) ? .PlayingStream : .PlayingQueue
        case "PAUSED_PLAYBACK"?:
            return .PausedQueue
        default:
            return .StoppedStream
        }
    }
}
