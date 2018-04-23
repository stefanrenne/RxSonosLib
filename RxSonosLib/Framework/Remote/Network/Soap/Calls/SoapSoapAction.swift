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
//    case changeTrack(number: Int), seekTime(time: String)
//    case removeTrackFromQueue(number: Int), removeAllTracksFromQueue, addTrackToQueueEnd(uri: String), addTrackToQueuePlayNext(uri: String), setQueue(uri: String), setAVTransportURI(uri: String), becomeCoordinatorOfStandaloneGroup
    case play, pause, stop, previous, next, positionInfo, transportInfo, mediaInfo
    
    /* Music */
//    case listAvailableServices, getSessionId(Int, String)
    
    /* Group */
    case state
//    case groupAttributes
    
    /* ContentDirectory */
    case browse
//    case favorites, localFiles
    
    /* RenderingControl */
    case getVolume, setVolume(Int), getMute, setMute(Bool)
    
    /* DeviceProperties */
//    case getHouseholdID, getZoneInfo
    
    /* SystemProperties */
//    case getCustomerID, getRoomSerial
    
    
    var service: SonosSoapService {
        switch self {
//
        case .play, .pause, .stop, .positionInfo, .transportInfo, .mediaInfo, .previous, .next:
//        case .changeTrack, .seekTime, .addTrackToQueueEnd, .addTrackToQueuePlayNext, .removeTrackFromQueue, .removeAllTracksFromQueue, .setQueue, .setAVTransportURI, .becomeCoordinatorOfStandaloneGroup:
            return .transport
//        case .listAvailableServices, .getSessionId:
//            return .music
        case .state/*, .groupAttributes*/:
            return .group
        //        case .favorites, .localFiles
        case .browse:
            return .contentDirectory
        case .getVolume, .setVolume, .getMute, .setMute:
            return .renderingControl
//        case .getHouseholdID, .getZoneInfo:
//            return .deviceProperties
//        case .getCustomerID, .getRoomSerial:
//            return .systemProperties
        }
        
    }
    
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
//        case .listAvailableServices:
//            return "ListAvailableServices"
//        case .getSessionId:
//            return "GetSessionId"
        case .state:
            return "GetZoneGroupState"
//        case .groupAttributes:
//            return "GetZoneGroupAttributes"
//        case .favorites, .localFiles:
        case .browse:
            return "Browse"
        case .getVolume:
            return "GetVolume"
        case .setVolume:
            return "SetVolume"
        case .getMute:
            return "GetMute"
        case .setMute:
            return "SetMute"
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
        /*, .removeAllTracksFromQueue, .becomeCoordinatorOfStandaloneGroup*/
        case .positionInfo, .transportInfo, .mediaInfo, .getVolume, .getMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        case .play, .pause, .stop, .previous, .next:
            return "<InstanceID>0</InstanceID><Speed>1</Speed>"
        /*case .changeTrack(let number):
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
            return "<InstanceID>0</InstanceID><CurrentURI>\(uri)</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>"*/
        case .browse:
            return "<ObjectID>Q:0</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>*</Filter><StartingIndex>0</StartingIndex><RequestedCount>0</RequestedCount><SortCriteria></SortCriteria>"
        /*case .favorites:
            return "<ObjectID>FV:2</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        case .localFiles:
            return "<ObjectID>S:</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"*/
        case .setVolume(let amount):
            let cleanAmount = max(min(amount, 100), 0)
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredVolume>\(cleanAmount)</DesiredVolume>"
        case .setMute(let enable):
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>\(enable ? 1: 0)</DesiredMute>"
        /*case .getCustomerID:
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
