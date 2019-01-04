//
//  MoreViewModel.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

enum MoreType {
    case musicproviders
}

class MoreViewModel {
    
    let type: MoreType
    
    init(type: MoreType) {
        self.type = type
    }
    
    var title: String {
        switch type {
        case .musicproviders:
            return "Musicservices"
        }
    }
    
    var icon: UIImage? {
        return UIImage(named: "tile_add_services_xsmall")
    }
}
