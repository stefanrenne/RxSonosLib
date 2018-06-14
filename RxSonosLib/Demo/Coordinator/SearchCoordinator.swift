//
//  SearchCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol SearchRouter {
    
}

class SearchCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    private weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?, masterRouter: MasterRouter) {
        self.navigationController = navigationController
        self.masterRouter = masterRouter
    }
    
    private let viewController = SearchViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: false)
    }
    
}

extension SearchCoordinator: SearchRouter {
    
}
