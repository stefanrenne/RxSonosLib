//
//  Room.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class Room {
    
    private let ssdpDevice: SSDPDevice
    private let deviceDescription: DeviceDescription
    
    var hasProxy: Bool { return self.ssdpDevice.hasProxy }
    var name: String { return self.deviceDescription.name }
    var ip: URL { return self.ssdpDevice.ip }
    var uuid: String { return self.ssdpDevice.uuid! }
    var userAgent: String { return self.ssdpDevice.server }
    
    init(ssdpDevice: SSDPDevice, deviceDescription: DeviceDescription) {
        self.ssdpDevice = ssdpDevice
        self.deviceDescription = deviceDescription
    }
    
}

extension Room {
    public func getMute() -> Observable<Bool> {
        return SonosInteractor.getMute(for: self)
    }
    
    public func set(mute enabled: Bool) -> Observable<Bool> {
        return SonosInteractor.set(mute: enabled, for: self)
    }
}

extension Room: Equatable {
    public static func ==(lhs: Room, rhs: Room) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
