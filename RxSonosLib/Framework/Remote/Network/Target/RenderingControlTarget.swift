//
//  RenderingControlTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum RenderingControlTarget: SonosTargetType {
    
    case getVolume
    case setVolume(Int)
    case getMute
    case setMute(Bool)
    
    var action: String {
        switch self {
        case .getVolume:
            return "GetVolume"
        case .setVolume:
            return "SetVolume"
        case .getMute:
            return "GetMute"
        case .setMute:
            return "SetMute"
        }
    }
    
    var arguments: String? {
        switch self {
        case .getVolume, .getMute:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        case .setVolume(let amount):
            let cleanAmount = max(min(amount, 100), 0)
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredVolume>\(cleanAmount)</DesiredVolume>"
        case .setMute(let enable):
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>\(enable ? 1: 0)</DesiredMute>"
        }
    }
    
    var controllUrl: String {
        return "/MediaRenderer/RenderingControl/Control"
    }
    
    var eventUrl: String {
        return "/MediaRenderer/RenderingControl/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:RenderingControl:1"
    }
    
}
