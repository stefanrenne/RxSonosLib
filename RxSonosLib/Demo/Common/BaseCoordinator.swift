//
//  BaseCoordinator.swift
//  Demo App
//
//  Created by Stefan Renne on 09/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class BaseCoordinator {
    
    internal weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func setup() -> UIViewController {
        fatalError("Override in subclass")
    }
}
