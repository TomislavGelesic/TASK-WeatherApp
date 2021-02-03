//
//  AppCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit


class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        
        goToHomeScene()
    }
    
    init() {
        
        window = UIWindow()
        window?.backgroundColor = .white
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.navigationController = navigationController
        
        initializeUserSettings()
    }
}

extension AppCoordinator {
    
    func initializeUserSettings() {
        
        let userDefaults = UserDefaults.standard
        let settings = UserDefaultsService()
        
        
        userDefaults.setValue(settings.lastCityId, forKey: Constants.UserDefaults.CITY_ID)
        userDefaults.setValue("metric", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
        userDefaults.setValue(settings.shouldShowHumidity, forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY)
        userDefaults.setValue(settings.shouldShowPressure, forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE)
        userDefaults.setValue(settings.shouldShowWindSpeed, forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED)
        userDefaults.setValue(settings.weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(settings.dayTime, forKey: Constants.UserDefaults.IS_DAY_TIME)
    }
    
    func childDidFinish(_ coordinator: Coordinator, goTo nextScene: SceneOption) {
        
        navigationController.viewControllers.removeAll()
        
        var indexToRemove = 0
        
        for (index, childCoordinator) in childCoordinators.enumerated() {
            if childCoordinator === coordinator {
                indexToRemove = index
                print("Child (\(childCoordinator.self)) with index \(index) did finish. ")
            }
        }
        
        childCoordinators.removeAll()
        
        switch nextScene {
        case .homeScene:
            goToHomeScene()
            break
        case .searchScene:
            goToSearchScene()
            break
        case .settingsScene:
            
                #warning("delete print")
                print("step 2")
            goToSettingsScene()
            break
        }
        
        
    }
    
    func goToHomeScene(){
        
        let child = HomeSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
        
    }
    
    func goToSearchScene() {
        
        let child = SearchSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
    
    func goToSettingsScene() {
        
        let child = SettingsSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
    
}

