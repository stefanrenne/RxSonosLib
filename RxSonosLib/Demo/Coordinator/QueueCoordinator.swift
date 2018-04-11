//
//  QueueCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol QueueRouter {
    func close()
}

class QueueCoordinator: BaseCoordinator {
    
    override func setup() -> UIViewController {
        let viewController = QueueViewController()
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.topViewController?.present(viewController, animated: true, completion: nil)
    }
    
}

extension QueueCoordinator: QueueRouter {
    func close() {
        self.navigationController?.topViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
