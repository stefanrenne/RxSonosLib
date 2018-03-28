//
//  SonosSoapService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


enum SonosSoapService {
    case group, transport
//    case alarm, groupRenderingControl, connectionManager, queue, music, contentDirectory, renderingControl, deviceProperties, systemProperties, musicProvider
    
    var controllUrl: String {
        switch self {
//        case .alarm:
//            return "/AlarmClock/Control"
//        case .connectionManager:
//            return "/MediaRenderer/ConnectionManager/Control"
        case .transport:
            return "/MediaRenderer/AVTransport/Control"
//        case .queue:
//            return "/MediaRenderer/Queue/Control"
//        case .music:
//            return "/MusicServices/Control"
        case .group:
            return "/ZoneGroupTopology/Control"
//        case .groupRenderingControl:
//            return "/MediaRenderer/GroupRenderingControl/Control"
//        case .contentDirectory:
//            return "/MediaServer/ContentDirectory/Control"
//        case .renderingControl:
//            return "/MediaRenderer/RenderingControl/Control"
//        case .deviceProperties:
//            return "/DeviceProperties/Control"
//        case .systemProperties:
//            return "/SystemProperties/Control"
//        case .musicProvider:
//            return ""
        }
    }
    
    /*var eventUrl: String {
        switch self {
            
            /* Subscribe Once */
        case .queue:
            return "/MediaRenderer/Queue/Event"
        case .music:
            return "/MusicServices/Event"
            
            /* Subscribe per group */
        case .Transport:
            return "/MediaRenderer/AVTransport/Event"
        case .systemProperties:
            return "/SystemProperties/Event"
        case .group:
            return "/ZoneGroupTopology/Event"
        case .groupRenderingControl:
            return "/MediaRenderer/GroupRenderingControl/Event"
            
            /* Subscribe per Room */
        case .contentDirectory:
            return "/MediaServer/ContentDirectory/Event"
        case .renderingControl:
            return "/MediaRenderer/RenderingControl/Event"
        case .alarm:
            return "/AlarmClock/Event"
            
            /* Unused */
        case .deviceProperties:
            return "/DeviceProperties/Event"
        case .connectionManager:
            return "/MediaRenderer/ConnectionManager/Event"
        case .musicProvider:
            return ""
        }
    }*/
    
    var schema: String {
        switch self {
//        case .alarm:
//            return "urn:schemas-upnp-org:service:AlarmClock:1"
        case .transport:
            return "urn:schemas-upnp-org:service:AVTransport:1"
//        case .queue:
//            return "urn:schemas-sonos-com:service:Queue:1"
//        case .music:
//            return "urn:schemas-upnp-org:service:MusicServices:1"
        case .group:
            return "urn:schemas-upnp-org:service:ZoneGroupTopology:1"
//        case .contentDirectory:
//            return "urn:schemas-upnp-org:service:ContentDirectory:1"
//        case .renderingControl:
//            return "urn:schemas-upnp-org:service:RenderingControl:1"
//        case .groupRenderingControl:
//            return "urn:schemas-upnp-org:service:GroupRenderingControl:1"
//        case .deviceProperties:
//            return "urn:schemas-upnp-org:service:DeviceProperties:1"
//        case .systemProperties:
//            return "urn:schemas-upnp-org:service:SystemProperties:1"
//        case .connectionManager:
//            return "urn:schemas-upnp-org:service:ConnectionManager:1"
//        case .musicProvider:
//            return "http://www.sonos.com/Services/1.1"
        }
    }
}
