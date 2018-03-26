//
//  GroupCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 13/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol GroupRouter {
    
}

class GroupCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
    fileprivate let group: Group
    init(navigationController: UINavigationController?, group: Group) {
        self.navigationController = navigationController
        self.group = group
    }
    
    func setup() -> UIViewController {
        let viewController = GroupViewController()
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.show(viewController, sender: self)
    }
    
}

extension GroupCoordinator: GroupRouter {
    
}
