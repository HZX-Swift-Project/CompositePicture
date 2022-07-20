//
//  AppDelegate.swift
//  CompositePicture
//
//  Created by Meet on 2022/7/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let VC = ViewController()
        self.window?.rootViewController = VC
        self.window?.makeKeyAndVisible()
        return true
    }


}

