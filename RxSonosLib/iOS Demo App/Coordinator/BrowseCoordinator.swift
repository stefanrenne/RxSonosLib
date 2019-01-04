//
//  BrowseCoordinator.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol BrowseRouter {
    
}

class BrowseCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    private weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?, masterRouter: MasterRouter) {
        self.navigationController = navigationController
        self.masterRouter = masterRouter
    }
    
    private let viewController = BrowseViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: false)
    }
    
}

extension BrowseCoordinator: BrowseRouter {
    
}
