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

class NowPlayingCoordinator: Coordinator {
    
    private let masterRouter: MasterRouter
    init(masterRouter: MasterRouter) {
        self.masterRouter = masterRouter
    }
    
    private let viewController = NowPlayingViewController()
    func setup() -> UIViewController {
        viewController.router = self
        return viewController
    }
}

extension NowPlayingCoordinator: NowPlayingRouter {
    
    func close() {
        masterRouter.closeNowPlaying()
    }
    
    func continueToQueue() {
        QueueCoordinator(masterRouter: masterRouter).start()
    }
    
}
