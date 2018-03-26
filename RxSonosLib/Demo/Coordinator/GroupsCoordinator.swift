//
//  GroupsCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol GroupsRouter {
    func continueToGroup(_ group: Group)
}

class GroupsCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func setup() -> UIViewController {
        let viewController = GroupsViewController()
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.show(viewController, sender: self)
    }
    
}

extension GroupsCoordinator: GroupsRouter {
    
    func continueToGroup(_ group: Group) {
        GroupCoordinator(navigationController: navigationController, group: group).start()
    }
    
}
