//
//  TransportTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum TransportTarget: SonosTargetType {
    
    case play
    case pause
    case stop
    case previous
    case next
    case positionInfo
    case transportInfo
    case mediaInfo
    //    case changeTrack(number: Int)
    //    case seekTime(time: String)
    //    case removeTrackFromQueue(number: Int)
    //    case removeAllTracksFromQueue
    //    case addTrackToQueueEnd(uri: String)
    //    case addTrackToQueuePlayNext(uri: String)
    //    case setQueue(uri: String)
    //    case setAVTransportURI(uri: String)
    //    case becomeCoordinatorOfStandaloneGroup
    
    var action: String {
        switch self {
        case .play:
            return "Play"
        case .pause:
            return "Pause"
        case .stop:
            return "Stop"
        case .previous:
            return "Previous"
        case .next:
            return "Next"
//        case .changeTrack, .seekTime:
//            return "Seek"
//        case .addTrackToQueueEnd, .addTrackToQueuePlayNext:
//            return "AddURIToQueue"
//        case .removeTrackFromQueue:
//            return "RemoveTrackFromQueue"
        case .positionInfo:
            return "GetPositionInfo"
        case .transportInfo:
            return "GetTransportInfo"
        case .mediaInfo:
            return "GetMediaInfo"
//        case .removeAllTracksFromQueue:
//            return "RemoveAllTracksFromQueue"
//        case .setQueue:
//            return "SetAVTransportURI"
//        case .setAVTransportURI:
//            return "SetAVTransportURI"
//        case .becomeCoordinatorOfStandaloneGroup:
//            return "BecomeCoordinatorOfStandaloneGroup"
        }
    }
    
    var arguments: String? {
        switch self {
        case .positionInfo, .transportInfo, .mediaInfo/*, .removeAllTracksFromQueue, .becomeCoordinatorOfStandaloneGroup*/:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        case .play, .pause, .stop, .previous, .next:
            return "<InstanceID>0</InstanceID><Speed>1</Speed>"
//        case .setQueue(let uri), .setAVTransportURI(let uri):
//            return "<InstanceID>0</InstanceID><CurrentURI>\(uri)</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>"
//        case .addTrackToQueuePlayNext(let uri):
//            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>1</EnqueueAsNext>"
//        case .addTrackToQueueEnd(let uri):
//            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>0</EnqueueAsNext>"
//        case .removeTrackFromQueue(let number):
//            return "<InstanceID>0</InstanceID><ObjectID>Q:0/\(number)</ObjectID>"
//        case .seekTime(let time):
//            return "<InstanceID>0</InstanceID><Unit>REL_TIME</Unit><Target>\(time)</Target>"
//        case .changeTrack(let number):
//            return "<InstanceID>0</InstanceID><Unit>TRACK_NR</Unit><Target>\(number)</Target>"
        }
    }
    
    var controllUrl: String {
        return "/MediaRenderer/AVTransport/Control"
    }
    
    var eventUrl: String {
        return "/MediaRenderer/AVTransport/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:AVTransport:1"
    }
    
}
