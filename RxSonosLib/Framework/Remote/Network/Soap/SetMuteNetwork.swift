//
//  SetMuteNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SetMuteNetwork: SoapNetwork {
    
    init(room: Room, enabled: Bool) {
        super.init(room: room, action: .setMute(enabled))
    }
    
}
