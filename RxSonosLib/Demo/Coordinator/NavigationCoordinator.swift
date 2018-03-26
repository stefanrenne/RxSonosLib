//
//  NavigationCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class NavigationCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func setup() -> UIViewController {
        let navigationController = NavigationController()
        
        GroupsCoordinator(navigationController: navigationController).start()
        
        return navigationController
    }

    func start() {
        let viewController = self.setup()
        self.navigationController?.visibleViewController?.show(viewController, sender: self)
    }
    
}
