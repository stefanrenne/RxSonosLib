//
//  BrowseViewController.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    
    internal var router: BrowseRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}
