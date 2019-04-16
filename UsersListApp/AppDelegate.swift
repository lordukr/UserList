//
//  AppDelegate.swift
//  UsersListApp
//
//  Created by My mac on 10/17/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
        let coordinator = MainCoordinator()
        coordinator.navigationController = navigation
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        coordinator.start()
        
        return true
    }
}

