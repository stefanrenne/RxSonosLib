//
//  TabBarCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 06/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSonosLib

protocol TabBarRouter {
    func continueToNowPlaying()
    func closeNowPlaying()
    func continueToQueue()
    func continueToMySonos()
    func continueToBrowse()
    func continueToRooms()
    func continueToSearch()
    func continueToMore()
}

protocol TabBarActions {
    func didLoad()
}

class TabBarCoordinator: BaseCoordinator {
    
    fileprivate var contentCoordinator: PageNavigationCoordinator?
    fileprivate var groupCoordinator: NowPlayingCoordinator?
    
    override init(navigationController: UINavigationController? = nil) {
        super.init(navigationController: navigationController)
        self.viewController.actions = self
        self.viewController.router = self
    }
    
    fileprivate let viewController = TabBarViewController()
    override func setup() -> UIViewController {
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
}

extension TabBarCoordinator: TabBarActions {
    func didLoad() {
        let nowPlayingCoordinator = NowPlayingCoordinator(tabBarRouter: self)
        self.viewController.fullNowPlayingView.load(view: nowPlayingCoordinator.setup().view)
        self.groupCoordinator = nowPlayingCoordinator
        
        let contentCoordinator = PageNavigationCoordinator(tabbarRouter: self)
        self.viewController.contentView.load(view: contentCoordinator.setup().view)
        self.contentCoordinator = contentCoordinator
    }
}

extension TabBarCoordinator: TabBarRouter {
    
    func continueToNowPlaying() {
        viewController.nowPlayingAction(collapse: false)
    }
    
    func closeNowPlaying() {
        viewController.nowPlayingAction(collapse: true)
    }
    
    func continueToQueue() {
        QueueCoordinator(navigationController: navigationController).start()
    }
    
    func continueToMySonos() {
        self.contentCoordinator?.continueToMySonos()
    }
    
    func continueToBrowse() {
        self.contentCoordinator?.continueToBrowse()
    }
    
    func continueToRooms() {
        self.contentCoordinator?.continueToRooms()
    }
    
    func continueToSearch() {
        self.contentCoordinator?.continueToSearch()
    }
    
    func continueToMore() {
        self.contentCoordinator?.continueToMore()
    }
    
}

fileprivate extension UIView {
    func load(view: UIView) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.addSubview(view)
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
