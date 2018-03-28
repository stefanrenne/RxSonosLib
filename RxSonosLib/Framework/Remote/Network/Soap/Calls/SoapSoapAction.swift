//
//  SoapSoapAction.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum SoapSoapAction {
    
    
    /* Transport */
//    case play, pause, stop, previous, next
//    case changeTrack(number: Int), seekTime(time: String)
//    case removeTrackFromQueue(number: Int), removeAllTracksFromQueue, addTrackToQueueEnd(uri: String), addTrackToQueuePlayNext(uri: String), setQueue(uri: String), setAVTransportURI(uri: String), becomeCoordinatorOfStandaloneGroup
    case nowPlaying, transportInfo, mediaInfo
    
    /* Music */
//    case listAvailableServices, getSessionId(Int, String)
    
    /* Group */
    case state
//    case groupAttributes
    
    /* ContentDirectory */
//    case browse(filter: String, start: Int, count: Int, sort: String), favorites, localFiles
    
    /* RenderingControl */
//    case getVolume, setVolume(_: Int), getMute, enableMute, disableMute
    
    /* DeviceProperties */
//    case getHouseholdID, getZoneInfo
    
    /* SystemProperties */
//    case getCustomerID, getRoomSerial
    
    
    var service: SonosSoapService {
        switch self {
//
        case .nowPlaying, .transportInfo, .mediaInfo:
//        case .play, .pause, .stop, .previous, .next, .changeTrack, .seekTime, .addTrackToQueueEnd, .addTrackToQueuePlayNext, .removeTrackFromQueue, .removeAllTracksFromQueue, .setQueue, .setAVTransportURI, .becomeCoordinatorOfStandaloneGroup:
            return .transport
//        case .listAvailableServices, .getSessionId:
//            return .music
        case .state/*, .groupAttributes*/:
            return .group
//        case .browse, .favorites, .localFiles:
//            return .contentDirectory
//        case .getVolume, .setVolume, .getMute, .enableMute, .disableMute:
//            return .renderingControl
//        case .getHouseholdID, .getZoneInfo:
//            return .deviceProperties
//        case .getCustomerID, .getRoomSerial:
//            return .systemProperties
        }
        
    }
    
    var action: String {
        switch self {
//        case .play:
//            return "Play"
//        case .pause:
//            return "Pause"
//        case .stop:
//            return "Stop"
//        case .previous:
//            return "Previous"
//        case .next:
//            return "Next"
//        case .changeTrack, .seekTime:
//            return "Seek"
//        case .addTrackToQueueEnd, .addTrackToQueuePlayNext:
//            return "AddURIToQueue"
//        case .removeTrackFromQueue:
//            return "RemoveTrackFromQueue"
        case .nowPlaying:
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
//        case .listAvailableServices:
//            return "ListAvailableServices"
//        case .getSessionId:
//            return "GetSessionId"
        case .state:
            return "GetZoneGroupState"
//        case .groupAttributes:
//            return "GetZoneGroupAttributes"
//        case .browse, .favorites, .localFiles:
//            return "Browse"
//        case .getVolume:
//            return "GetVolume"
//        case .setVolume:
//            return "SetVolume"
//        case .getMute:
//            return "GetMute"
//        case .enableMute, .disableMute:
//            return "SetMute"
//        case .getHouseholdID:
//            return "GetHouseholdID"
//        case .getZoneInfo:
//            return "GetZoneInfo"
//        case .getCustomerID, .getRoomSerial:
//            return "GetString"
        }
    }
    
    var arguments: String? {
        switch self {
        case .nowPlaying, .transportInfo, .mediaInfo/*, .removeAllTracksFromQueue, .getVolume, .getMute, .becomeCoordinatorOfStandaloneGroup*/:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        /*case .play, .pause, .previous, .next, .stop:
            return "<InstanceID>0</InstanceID><Speed>1</Speed>"
        case .changeTrack(let number):
            return "<InstanceID>0</InstanceID><Unit>TRACK_NR</Unit><Target>\(number)</Target>"
        case .seekTime(let time):
            return "<InstanceID>0</InstanceID><Unit>REL_TIME</Unit><Target>\(time)</Target>"
        case .removeTrackFromQueue(let number):
            return "<InstanceID>0</InstanceID><ObjectID>Q:0/\(number)</ObjectID>"
        case .addTrackToQueueEnd(let uri):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>0</EnqueueAsNext>"
        case .addTrackToQueuePlayNext(let uri):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>1</EnqueueAsNext>"
        case .setQueue(let uri), .setAVTransportURI(let uri):
            return "<InstanceID>0</InstanceID><CurrentURI>\(uri)</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>"
        case .browse(let filter, let start, let count, let sort):
            return "<ObjectID>Q:0</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>\(filter)</Filter><StartingIndex>\(start)</StartingIndex><RequestedCount>\(count)</RequestedCount><SortCriteria>\(sort)</SortCriteria>"
        case .favorites:
            return "<ObjectID>FV:2</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        case .localFiles:
            return "<ObjectID>S:</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        case .setVolume(let amount):
            let cleanAmount = max(min(amount, 100), 0)
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredVolume>\(cleanAmount)</DesiredVolume>"
        case .enableMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>1</DesiredMute>"
        case .disableMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>0</DesiredMute>"
        case .getCustomerID:
            return "<VariableName>R_CustomerID</VariableName>"
        case .getRoomSerial:
            return "<VariableName>R_TrialZPSerial</VariableName>"
        case .getSessionId(let serviceId, let username):
            return "<ServiceId>\(serviceId)</ServiceId><Username>\(username)</Username>"*/
        default:
            return nil
        }
    }
    
    var soapAction: String {
        return service.schema + "#" + action
    }
}
