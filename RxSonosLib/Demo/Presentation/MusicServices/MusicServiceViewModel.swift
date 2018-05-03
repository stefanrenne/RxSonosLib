//
//  MusicServicesViewModel.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxSonosLib

class MusicServiceViewModel {
    
    private let service: MusicService
    
    init(service: MusicService) {
        self.service = service
    }
    
    var name: String { return service.name }
}
