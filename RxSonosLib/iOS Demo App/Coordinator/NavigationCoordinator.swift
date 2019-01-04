//
//  NavigationCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class NavigationCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func setup() -> UIViewController {
        let navigationController = NavigationController()
        
        LoadingCoordinator(navigationController: navigationController).start()
        
        return navigationController
    }
    
}
