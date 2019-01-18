//
//  RoomsCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol RoomsRouter {
    func continueTo(group: Group)
}

class RoomsCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let masterRouter: MasterRouter
    init(navigationController: UINavigationController?, masterRouter: MasterRouter) {
        self.navigationController = navigationController
        self.masterRouter = masterRouter
    }
    
    private let viewController = RoomsViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = setup()
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
}

extension RoomsCoordinator: RoomsRouter {
    
    func continueTo(group: Group) {
        masterRouter.continueTo(group: group)
    }
    
}
