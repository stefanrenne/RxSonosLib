//
//  PageNavigationCoordinator.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

protocol PageNavigationRouter {
    func continueToMySonos()
    func continueToBrowse()
    func continueToRooms()
    func continueToSearch()
    func continueToMore()
}

class PageNavigationCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    init(masterRouter: MasterRouter) {
        self.masterRouter = masterRouter
    }
    
    private let viewController = PageNavigationController()
    func setup() -> UIViewController {
        return viewController
    }
    
}

extension PageNavigationCoordinator: PageNavigationRouter {
    
    func continueToMySonos() {
        MySonosCoordinator(navigationController: viewController, masterRouter: masterRouter).start()
    }
    
    func continueToBrowse() {
        BrowseCoordinator(navigationController: viewController, masterRouter: masterRouter).start()
    }
    
    func continueToRooms() {
        RoomsCoordinator(navigationController: viewController, masterRouter: masterRouter).start()
    }
    
    func continueToSearch() {
        SearchCoordinator(navigationController: viewController, masterRouter: masterRouter).start()
    }
    
    func continueToMore() {
        MoreCoordinator(navigationController: viewController, masterRouter: masterRouter).start()
    }
}
