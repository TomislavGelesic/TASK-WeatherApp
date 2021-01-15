//
//  AppDelegate.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = .white
        let rootViewController = SearchSceneViewController()
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

}

