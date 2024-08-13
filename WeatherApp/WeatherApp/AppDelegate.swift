//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by 유민우 on 7/13/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = DetailDayViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}

