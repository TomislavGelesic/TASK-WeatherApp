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
    
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = .white
        
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        
        appCoordinator?.start()
        
        return true
    }

}

