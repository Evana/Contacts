//
//  AppDelegate.swift
//  Contacts
//
//  Created by Evana Islam on 2/3/19.
//  Copyright © 2019 Evana Islam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        navController.navigationBar.barTintColor = .white
        let titleDict = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navController.navigationBar.titleTextAttributes = titleDict
        navController.navigationBar.isTranslucent = false
        let mainView = ContactListViewController(nibName: nil, bundle: nil)
        navController.viewControllers = [mainView]
        self.window!.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }

}

