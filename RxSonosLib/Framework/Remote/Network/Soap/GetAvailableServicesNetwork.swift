//
//  GetAvailableServicesNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class GetAvailableServicesNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .listAvailableServices)
    }
    
}
