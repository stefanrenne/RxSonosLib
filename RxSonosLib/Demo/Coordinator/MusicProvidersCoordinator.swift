//
//  MusicProvidersCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol MusicProvidersRouter {
    func didClose()
    func didSelect(service: MusicProvider)
}

class MusicProvidersCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    init(masterRouter: MasterRouter) {
        self.masterRouter = masterRouter
    }
    
    private let viewController = MusicProvidersViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        masterRouter.present(viewController)
    }
}

extension MusicProvidersCoordinator: MusicProvidersRouter {
    
    func didClose() {
        masterRouter.dismiss()
    }

    func didSelect(service: MusicProvider) {
        
    }
    
}
