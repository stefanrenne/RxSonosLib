//
//  TabBarCoordinator.swift
//  iOS Demo App
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
    
    private var contentCoordinator: PageNavigationCoordinator?
    private var groupCoordinator: NowPlayingCoordinator?
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        self.viewController.actions = self
        self.viewController.router = self
    }
    
    private let viewController = TabBarViewController()
    func setup() -> UIViewController {
        return viewController
    }
    
    func start() {
        let viewController = setup()
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
}

extension TabBarCoordinator: TabBarActions {
    func didLoad() {
        let nowPlayingCoordinator = NowPlayingCoordinator(masterRouter: self)
        viewController.fullNowPlayingView.load(view: nowPlayingCoordinator.setup().view)
        groupCoordinator = nowPlayingCoordinator
        
        let contentCoordinator = PageNavigationCoordinator(masterRouter: self)
        viewController.contentView.load(view: contentCoordinator.setup().view)
        self.contentCoordinator = contentCoordinator
    }
    
    func didUpdateActiveGroup() {
        viewController.nowPlayingAction(collapse: false)
    }
}

extension TabBarCoordinator: TabBarRouter {
    
    func continueToMySonos() {
        contentCoordinator?.continueToMySonos()
    }
    
    func continueToBrowse() {
        contentCoordinator?.continueToBrowse()
    }
    
    func continueToRooms() {
        contentCoordinator?.continueToRooms()
    }
    
    func continueToSearch() {
        contentCoordinator?.continueToSearch()
    }
    
    func continueToMore() {
        contentCoordinator?.continueToMore()
    }
    
}

extension TabBarCoordinator: MasterRouter {
    func present(_ viewController: UIViewController) {
        navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController?.topViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
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
        subviews.forEach({ $0.removeFromSuperview() })
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
