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
    func continueToNowPlaying()
}

class RoomsCoordinator: BaseCoordinator {
    
    private let tabbarRouter: TabBarRouter
    init(navigationController: UINavigationController?, tabbarRouter: TabBarRouter) {
        self.tabbarRouter = tabbarRouter
        super.init(navigationController: navigationController)
    }
    
    private let viewController = RoomsViewController()
    override func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: false)
    }
    
}

extension RoomsCoordinator: RoomsRouter {
    
    func continueToNowPlaying() {
        self.tabbarRouter.continueToNowPlaying()
    }
    
}
