//
//  MusicService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public enum ContainerType: String {
    case musicService = "MService"
    case soundLab = "SoundLab"
}

public enum AuthenticationPolicy: String {
    case anonymous = "Anonymous"
    case appLink = "AppLink"
    case userId = "UserId"
    case deviceLink = "DeviceLink"
}

open class Presentation {
    public let uri: URL
    public let version: Int
    
    init(uri: URL, version: Int) {
        self.uri = uri
        self.version = version
    }
}

open class MusicService {
    public let id: Int
    public let name: String
    public let uri: URL
    public let type: ContainerType
    public let policy: AuthenticationPolicy
    public let map: Presentation
    public let strings: Presentation?
    
    init(id: Int, name: String, uri: URL, type: ContainerType, policy: AuthenticationPolicy, map: Presentation, strings: Presentation?) {
        self.id = id
        self.name = name
        self.uri = uri
        self.type = type
        self.policy = policy
        self.map = map
        self.strings = strings
    }
    
}
