//
//  NavigationController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.blue
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
        self.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 27)]
        } else {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
