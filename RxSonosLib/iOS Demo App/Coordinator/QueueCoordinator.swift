//
//  QueueCoordinator.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol QueueRouter {
    func close()
}

class QueueCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    init(masterRouter: MasterRouter) {
        self.masterRouter = masterRouter
    }
    
    func setup() -> UIViewController {
        let viewController = QueueViewController()
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        masterRouter.present(viewController)
    }
    
}

extension QueueCoordinator: QueueRouter {
    func close() {
        masterRouter.dismiss()
    }
}
