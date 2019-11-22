//
//  AppDelegate.swift
//  FlickrAndCoreData
//
//  Created by nate.taylor_macbook on 21/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationRootViewController = FlickrViewController()
        let navigationController = UINavigationController(rootViewController: navigationRootViewController)
        
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
