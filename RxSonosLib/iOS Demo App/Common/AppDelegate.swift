//
//  AppDelegate.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/10/2017.
//  Copyright © 2017 Uberweb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.statusBarStyle = .lightContent
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = NavigationCoordinator().setup()
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
