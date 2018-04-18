//
//  SetNextNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SetNextNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .next)
    }
    
}
