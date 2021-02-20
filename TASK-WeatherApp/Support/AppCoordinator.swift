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
        UserDefaultsService.update(with: UserDefaultsService.fetchUpdated())        
    }
    
    func childDidFinish(_ coordinator: Coordinator, goTo nextScene: SceneOption) {
        
        navigationController.viewControllers.removeAll()
        
        childCoordinators = childCoordinators.filter({ (coord) -> Bool in
            if coord === coordinator {
//                print("Child (\(coord.self)) did finish. ")
                return false
            } else {
                return true
            }
        })
        
        switch nextScene {
        case .homeScene:
            goToHomeScene()
            break
        case .searchScene:
            goToSearchScene()
            break
        case .settingsScene:
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

