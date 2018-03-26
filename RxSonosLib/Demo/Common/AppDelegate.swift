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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
//        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
//        RepositoryInjection.shared.groupRepository = FakeGroupRepositoryImpl()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = NavigationCoordinator().setup()
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
