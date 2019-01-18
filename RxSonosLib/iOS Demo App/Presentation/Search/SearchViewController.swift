//
//  SearchViewController.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    internal var router: SearchRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}
