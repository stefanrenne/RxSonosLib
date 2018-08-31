//
//  GroupRenderingControlTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum GroupRenderingControlTarget: SonosTargetType {
    
    var action: String {
        switch self {
        }
    }
    
    var arguments: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var controllUrl: String {
        return "/MediaRenderer/GroupRenderingControl/Control"
    }
    
    var eventUrl: String {
        return "/MediaRenderer/GroupRenderingControl/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:GroupRenderingControl:1"
    }
}
