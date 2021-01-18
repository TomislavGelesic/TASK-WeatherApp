//
//  AppCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit


class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        
        goToHomeScene()
    }
    
    init(navigationController: UINavigationController) {
        
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
    }
    
    func goToHomeScene(){

        childCoordinators.removeAll()
        
        let child = HomeSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
        
    }
    
    func goToSearchScene() {
        
        childCoordinators.removeAll()
        
        let child = SearchSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
    
    func goToSettingsScene() {
        
        childCoordinators.removeAll()
        
        let child = SettingsSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
    
}

