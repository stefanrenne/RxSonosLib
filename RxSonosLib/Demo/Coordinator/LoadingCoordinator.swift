//
//  LoadingCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 09/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

protocol LoadingRouter {
    func continueToMySonos()
}

class LoadingCoordinator: BaseCoordinator {
    
    override func setup() -> UIViewController {
        let viewController = LoadingViewController()
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: false)
    }
    
}

extension LoadingCoordinator: LoadingRouter {
    func continueToMySonos() {
        TabBarCoordinator(navigationController: self.navigationController).start()
    }
}
