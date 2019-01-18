//
//  PageNavigationController.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 10/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit

class PageNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.styleWhite()
        navigationBar.shadowImage = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0).as1ptImage()
        navigationItem.hidesBackButton = false
    }

}

extension UINavigationBar {
    func styleWhite() {
        isTranslucent = false
        
        tintColor = UIColor.black
        barTintColor = UIColor.white
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        
        setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
    }
}

fileprivate extension UIColor {
    
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
