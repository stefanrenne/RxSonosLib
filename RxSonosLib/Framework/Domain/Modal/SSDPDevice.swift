//
//  SSDPDevice.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

open class SSDPDevice {
    let ip: URL
    let usn: String
    let server: String
    let ext: String
    let st: String
    let location: String
    let cacheControl: String
    
    /* Sonos Specific SSDP Response */
    let uuid: String?
    let wifiMode: String?
    let variant: String?
    let household: String?
    let bootseq: String?
    let proxy: String?
    
    init(ip: URL, usn: String, server: String, ext: String, st: String, location: String, cacheControl: String, uuid: String?, wifiMode: String?, variant: String?, household: String?, bootseq: String?, proxy: String?) {
        self.ip = ip
        self.usn = usn
        self.server = server
        self.ext = ext
        self.st = st
        self.location = location
        self.cacheControl = cacheControl
        self.uuid = uuid
        self.wifiMode = wifiMode
        self.variant = variant
        self.household = household
        self.bootseq = bootseq
        self.proxy = proxy
    
    }
    
}

extension SSDPDevice: Equatable {
    public static func ==(lhs: SSDPDevice, rhs: SSDPDevice) -> Bool {
        return lhs.usn == rhs.usn
    }
}

extension SSDPDevice {
    
    var isSonosDevice: Bool {
        if let household = self.household,
            let uuid = self.uuid,
            !household.isEmpty,
            !uuid.isEmpty {
            return true
        }
        return false
    }
    
    var hasProxy: Bool {
        if let proxy = self.proxy,
            !proxy.isEmpty {
            return true
        }
        return false
    }
    
    class func map(_ response: SSDPResponse) -> SSDPDevice? {
        let data = response.responseDictionary
        
        guard let usn: String = data["USN"],
            let server: String = data["SERVER"],
            let ext: String = data["EXT"],
            let st: String = data["ST"],
            let locationString: String = data["LOCATION"],
            let cacheControl: String = data["CACHE-CONTROL"],
            let ipString = locationString.baseUrl(),
            let locationSuffix = locationString.urlSuffix(),
            let ip = URL(string: ipString) else {
                return nil
        }
        
        let uuid: String? = usn.extractUUID()
        let wifiMode: String? = data["X-RINCON-WIFIMODE"]
        let variant: String? = data["X-RINCON-VARIANT"]
        let household: String? = data["X-RINCON-HOUSEHOLD"]
        let bootseq: String? = data["X-RINCON-BOOTSEQ"]
        let proxy: String? = data["X-RINCON-PROXY"]
        
        return SSDPDevice(ip: ip, usn: usn, server: server, ext: ext, st: st, location: locationSuffix, cacheControl: cacheControl, uuid: uuid, wifiMode: wifiMode, variant: variant, household: household, bootseq: bootseq, proxy: proxy)
    }
}
