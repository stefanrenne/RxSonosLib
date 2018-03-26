//
//  GroupViewModel.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSonosLib

class GroupViewModel {
    
    fileprivate let group: Group
    init(group: Group) {
        self.group = group
    }
    
    var name: Variable<String> { return group.name }
    
}
