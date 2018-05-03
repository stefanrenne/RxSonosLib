//
//  MusicServicesCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol MusicServicesRouter {
    func didClose()
    func didSelect(service: MusicService)
}

class MusicServicesCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    init(masterRouter: MasterRouter) {
        self.masterRouter = masterRouter
    }
    
    private let viewController = MusicServicesViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        masterRouter.present(viewController)
    }
}

extension MusicServicesCoordinator: MusicServicesRouter {
    
    func didClose() {
        masterRouter.dismiss()
    }

    func didSelect(service: MusicService) {
        
    }
    
}
