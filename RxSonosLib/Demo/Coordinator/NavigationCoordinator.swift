//
//  NavigationCoordinator.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class NavigationCoordinator: BaseCoordinator {
    
    override func setup() -> UIViewController {
        let navigationController = NavigationController()
        
        LoadingCoordinator(navigationController: navigationController).start()
        
        return navigationController
    }
    
}
