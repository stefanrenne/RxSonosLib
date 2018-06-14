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
    func continueToMySonos()
    func continueToBrowse()
    func continueToRooms()
    func continueToSearch()
    func continueToMore()
}

protocol MasterRouter {
    func present(_ viewController: UIViewController)
    func dismiss()
    func closeNowPlaying()
    func continueTo(group: Group)
}

protocol TabBarActions {
    func didLoad()
    func didUpdateActiveGroup()
}

class TabBarCoordinator: Coordinator {
    
    fileprivate var contentCoordinator: PageNavigationCoordinator?
    fileprivate var groupCoordinator: NowPlayingCoordinator?
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.viewController.actions = self
        self.viewController.router = self
    }
    
    fileprivate let viewController = TabBarViewController()
    func setup() -> UIViewController {
        return viewController
    }
    
    func start() {
        let viewController = self.setup()
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
}

extension TabBarCoordinator: TabBarActions {
    func didLoad() {
        let nowPlayingCoordinator = NowPlayingCoordinator(masterRouter: self)
        self.viewController.fullNowPlayingView.load(view: nowPlayingCoordinator.setup().view)
        self.groupCoordinator = nowPlayingCoordinator
        
        let contentCoordinator = PageNavigationCoordinator(masterRouter: self)
        self.viewController.contentView.load(view: contentCoordinator.setup().view)
        self.contentCoordinator = contentCoordinator
    }
    
    func didUpdateActiveGroup() {
        viewController.nowPlayingAction(collapse: false)
    }
}

extension TabBarCoordinator: TabBarRouter {
    
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

extension TabBarCoordinator: MasterRouter {
    func present(_ viewController: UIViewController) {
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.navigationController?.topViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func closeNowPlaying() {
        viewController.nowPlayingAction(collapse: true)
    }
    
    func continueTo(group: Group) {
        viewController.nowPlayingAction(collapse: false)
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
