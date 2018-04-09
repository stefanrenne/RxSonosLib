//
//  NowPlayingCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 13/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol NowPlayingRouter {
    func close()
    func continueToQueue()
}

class NowPlayingCoordinator: BaseCoordinator {
    
    private let tabBarRouter: TabBarRouter
    init(navigationController: UINavigationController? = nil, tabBarRouter: TabBarRouter) {
        self.tabBarRouter = tabBarRouter
        super.init(navigationController: navigationController)
    }
    
    private let viewController = NowPlayingViewController()
    override func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
}

extension NowPlayingCoordinator: NowPlayingRouter {
    
    func close() {
        tabBarRouter.closeNowPlaying()
    }
    
    func continueToQueue() {
        tabBarRouter.continueToQueue()
    }
    
}
