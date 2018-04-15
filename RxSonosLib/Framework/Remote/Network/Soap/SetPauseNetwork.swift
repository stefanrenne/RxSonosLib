//
//  SetPauseNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 14/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SetPauseNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .pause)
    }
    
}
