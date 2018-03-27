//
//  SonosSoapService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


enum SonosSoapService {
    case Group, Transport
//    case Alarm, GroupRenderingControl, ConnectionManager, Queue, Music, ContentDirectory, RenderingControl, DeviceProperties, SystemProperties, MusicProvider
    
    var controllUrl: String {
        switch self {
//        case .Alarm:
//            return "/AlarmClock/Control"
//        case .ConnectionManager:
//            return "/MediaRenderer/ConnectionManager/Control"
        case .Transport:
            return "/MediaRenderer/AVTransport/Control"
//        case .Queue:
//            return "/MediaRenderer/Queue/Control"
//        case .Music:
//            return "/MusicServices/Control"
        case .Group:
            return "/ZoneGroupTopology/Control"
//        case .GroupRenderingControl:
//            return "/MediaRenderer/GroupRenderingControl/Control"
//        case .ContentDirectory:
//            return "/MediaServer/ContentDirectory/Control"
//        case .RenderingControl:
//            return "/MediaRenderer/RenderingControl/Control"
//        case .DeviceProperties:
//            return "/DeviceProperties/Control"
//        case .SystemProperties:
//            return "/SystemProperties/Control"
//        case .MusicProvider:
//            return ""
        }
    }
    
    /*var eventUrl: String {
        switch self {
            
            /* Subscribe Once */
        case .Queue:
            return "/MediaRenderer/Queue/Event"
        case .Music:
            return "/MusicServices/Event"
            
            /* Subscribe per group */
        case .Transport:
            return "/MediaRenderer/AVTransport/Event"
        case .SystemProperties:
            return "/SystemProperties/Event"
        case .Group:
            return "/ZoneGroupTopology/Event"
        case .GroupRenderingControl:
            return "/MediaRenderer/GroupRenderingControl/Event"
            
            /* Subscribe per Room */
        case .ContentDirectory:
            return "/MediaServer/ContentDirectory/Event"
        case .RenderingControl:
            return "/MediaRenderer/RenderingControl/Event"
        case .Alarm:
            return "/AlarmClock/Event"
            
            /* Unused */
        case .DeviceProperties:
            return "/DeviceProperties/Event"
        case .ConnectionManager:
            return "/MediaRenderer/ConnectionManager/Event"
        case .MusicProvider:
            return ""
        }
    }*/
    
    var schema: String {
        switch self {
//        case .Alarm:
//            return "urn:schemas-upnp-org:service:AlarmClock:1"
        case .Transport:
            return "urn:schemas-upnp-org:service:AVTransport:1"
//        case .Queue:
//            return "urn:schemas-sonos-com:service:Queue:1"
//        case .Music:
//            return "urn:schemas-upnp-org:service:MusicServices:1"
        case .Group:
            return "urn:schemas-upnp-org:service:ZoneGroupTopology:1"
//        case .ContentDirectory:
//            return "urn:schemas-upnp-org:service:ContentDirectory:1"
//        case .RenderingControl:
//            return "urn:schemas-upnp-org:service:RenderingControl:1"
//        case .GroupRenderingControl:
//            return "urn:schemas-upnp-org:service:GroupRenderingControl:1"
//        case .DeviceProperties:
//            return "urn:schemas-upnp-org:service:DeviceProperties:1"
//        case .SystemProperties:
//            return "urn:schemas-upnp-org:service:SystemProperties:1"
//        case .ConnectionManager:
//            return "urn:schemas-upnp-org:service:ConnectionManager:1"
//        case .MusicProvider:
//            return "http://www.sonos.com/Services/1.1"
        }
    }
}
