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
//    case Play, Pause, Stop, Previous, Next
//    case ChangeTrack(number: Int), SeekTime(time: String)
//    case RemoveTrackFromQueue(number: Int), RemoveAllTracksFromQueue, AddTrackToQueueEnd(uri: String), AddTrackToQueuePlayNext(uri: String), SetQueue(uri: String), SetAVTransportURI(uri: String), BecomeCoordinatorOfStandaloneGroup
    case NowPlaying, TransportInfo, MediaInfo
    
    /* Music */
//    case ListAvailableServices, GetSessionId(Int, String)
    
    /* Group */
    case State
//    case GroupAttributes
    
    /* ContentDirectory */
//    case Browse(filter: String, start: Int, count: Int, sort: String), Favorites, LocalFiles
    
    /* RenderingControl */
//    case GetVolume, SetVolume(_: Int), GetMute, EnableMute, DisableMute
    
    /* DeviceProperties */
//    case GetHouseholdID, GetZoneInfo
    
    /* SystemProperties */
//    case GetCustomerID, GetRoomSerial
    
    
    var service: SonosSoapService {
        switch self {
//
        case .NowPlaying, .TransportInfo, .MediaInfo:
//        case .Play, .Pause, .Stop, .Previous, .Next, .ChangeTrack, .SeekTime, .AddTrackToQueueEnd, .AddTrackToQueuePlayNext, .RemoveTrackFromQueue, .RemoveAllTracksFromQueue, .SetQueue, .SetAVTransportURI, .BecomeCoordinatorOfStandaloneGroup:
            return .Transport
//        case .ListAvailableServices, .GetSessionId:
//            return .Music
        case .State/*, .GroupAttributes*/:
            return .Group
//        case .Browse, .Favorites, .LocalFiles:
//            return .ContentDirectory
//        case .GetVolume, .SetVolume, .GetMute, .EnableMute, .DisableMute:
//            return .RenderingControl
//        case .GetHouseholdID, .GetZoneInfo:
//            return .DeviceProperties
//        case .GetCustomerID, .GetRoomSerial:
//            return .SystemProperties
        }
        
    }
    
    var action: String {
        switch self {
//        case .Play:
//            return "Play"
//        case .Pause:
//            return "Pause"
//        case .Stop:
//            return "Stop"
//        case .Previous:
//            return "Previous"
//        case .Next:
//            return "Next"
//        case .ChangeTrack, .SeekTime:
//            return "Seek"
//        case .AddTrackToQueueEnd, .AddTrackToQueuePlayNext:
//            return "AddURIToQueue"
//        case .RemoveTrackFromQueue:
//            return "RemoveTrackFromQueue"
        case .NowPlaying:
            return "GetPositionInfo"
        case .TransportInfo:
            return "GetTransportInfo"
        case .MediaInfo:
            return "GetMediaInfo"
//        case .RemoveAllTracksFromQueue:
//            return "RemoveAllTracksFromQueue"
//        case .SetQueue:
//            return "SetAVTransportURI"
//        case .SetAVTransportURI:
//            return "SetAVTransportURI"
//        case .BecomeCoordinatorOfStandaloneGroup:
//            return "BecomeCoordinatorOfStandaloneGroup"
//        case .ListAvailableServices:
//            return "ListAvailableServices"
//        case .GetSessionId:
//            return "GetSessionId"
        case .State:
            return "GetZoneGroupState"
//        case .GroupAttributes:
//            return "GetZoneGroupAttributes"
//        case .Browse, .Favorites, .LocalFiles:
//            return "Browse"
//        case .GetVolume:
//            return "GetVolume"
//        case .SetVolume:
//            return "SetVolume"
//        case .GetMute:
//            return "GetMute"
//        case .EnableMute, .DisableMute:
//            return "SetMute"
//        case .GetHouseholdID:
//            return "GetHouseholdID"
//        case .GetZoneInfo:
//            return "GetZoneInfo"
//        case .GetCustomerID, .GetRoomSerial:
//            return "GetString"
        }
    }
    
    var arguments: String? {
        switch self {
        case .NowPlaying, .TransportInfo, .MediaInfo/*, .RemoveAllTracksFromQueue, .GetVolume, .GetMute, .BecomeCoordinatorOfStandaloneGroup*/:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        /*case .Play, .Pause, .Previous, .Next, .Stop:
            return "<InstanceID>0</InstanceID><Speed>1</Speed>"
        case .ChangeTrack(let number):
            return "<InstanceID>0</InstanceID><Unit>TRACK_NR</Unit><Target>\(number)</Target>"
        case .SeekTime(let time):
            return "<InstanceID>0</InstanceID><Unit>REL_TIME</Unit><Target>\(time)</Target>"
        case .RemoveTrackFromQueue(let number):
            return "<InstanceID>0</InstanceID><ObjectID>Q:0/\(number)</ObjectID>"
        case .AddTrackToQueueEnd(let uri):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>0</EnqueueAsNext>"
        case .AddTrackToQueuePlayNext(let uri):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData></EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>1</EnqueueAsNext>"
        case .SetQueue(let uri), .SetAVTransportURI(let uri):
            return "<InstanceID>0</InstanceID><CurrentURI>\(uri)</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>"
        case .Browse(let filter, let start, let count, let sort):
            return "<ObjectID>Q:0</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>\(filter)</Filter><StartingIndex>\(start)</StartingIndex><RequestedCount>\(count)</RequestedCount><SortCriteria>\(sort)</SortCriteria>"
        case .Favorites:
            return "<ObjectID>FV:2</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        case .LocalFiles:
            return "<ObjectID>S:</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        case .SetVolume(let amount):
            let cleanAmount = max(min(amount, 100), 0)
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredVolume>\(cleanAmount)</DesiredVolume>"
        case .EnableMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>1</DesiredMute>"
        case .DisableMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>0</DesiredMute>"
        case .GetCustomerID:
            return "<VariableName>R_CustomerID</VariableName>"
        case .GetRoomSerial:
            return "<VariableName>R_TrialZPSerial</VariableName>"
        case .GetSessionId(let serviceId, let username):
            return "<ServiceId>\(serviceId)</ServiceId><Username>\(username)</Username>"*/
        default:
            return nil
        }
    }
    
    var soapAction: String {
        return service.schema + "#" + action
    }
}
