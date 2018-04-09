//
//  PageNavigationCoordinator.swift
//  Demo App
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

class PageNavigationCoordinator: BaseCoordinator {
    
    private let tabbarRouter: TabBarRouter
    init(navigationController: UINavigationController? = nil, tabbarRouter: TabBarRouter) {
        self.tabbarRouter = tabbarRouter
        super.init(navigationController: navigationController)
    }
    
    private let viewController = PageNavigationController()
    override func setup() -> UIViewController {
        return viewController
    }
    
}

extension PageNavigationCoordinator: PageNavigationRouter {
    
    func continueToMySonos() {
        MySonosCoordinator(navigationController: self.viewController, tabbarRouter: self.tabbarRouter).start()
    }
    
    func continueToBrowse() {
        BrowseCoordinator(navigationController: self.viewController, tabbarRouter: self.tabbarRouter).start()
    }
    
    func continueToRooms() {
        RoomsCoordinator(navigationController: self.viewController, tabbarRouter: self.tabbarRouter).start()
    }
    
    func continueToSearch() {
        SearchCoordinator(navigationController: self.viewController, tabbarRouter: self.tabbarRouter).start()
    }
    
    func continueToMore() {
        MoreCoordinator(navigationController: self.viewController, tabbarRouter: self.tabbarRouter).start()
    }
}
