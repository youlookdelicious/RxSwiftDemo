//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupRootViewController()
        
        return true
    }

    


}


// 初始化APP以及各种SDK
extension AppDelegate {
    
    func setupRootViewController() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        if UserDefaults.standard.object(forKey: "loginStatus") as? Bool ?? false {
            window?.rootViewController = TabBarViewController()
        } else {
            window?.rootViewController = LoginViewController()
        }
//        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }
    
}

// App状态切换
extension AppDelegate {
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}
