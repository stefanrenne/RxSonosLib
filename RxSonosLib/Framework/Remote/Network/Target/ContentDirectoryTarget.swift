//
//  ContentDirectoryTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum ContentDirectoryTarget: SonosTargetType {
    
    case browse
//    case favorites
//    case localFiles
    
    var action: String {
        switch self {
//        case .favorites, .localFiles:
        case .browse:
            return "Browse"
        }
    }
    
    var arguments: String? {
        switch self {
        case .browse:
            return "<ObjectID>Q:0</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>*</Filter><StartingIndex>0</StartingIndex><RequestedCount>0</RequestedCount><SortCriteria></SortCriteria>"
//        case .favorites:
//            return "<ObjectID>FV:2</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
//        case .localFiles:
//            return "<ObjectID>S:</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>dc:title,res,dc:creator,upnp:artist,upnp:album,upnp:albumArtURI</Filter><StartingIndex>0</StartingIndex><RequestedCount>100</RequestedCount><SortCriteria></SortCriteria>"
        }
    }
    
    var controllUrl: String {
        return "/MediaServer/ContentDirectory/Control"
    }
    
    var eventUrl: String {
        return "/MediaServer/ContentDirectory/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:ContentDirectory:1"
    }
    
}
