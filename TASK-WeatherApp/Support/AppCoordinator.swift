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
    
    func start() { goToHomeScene() }
    
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
        #warning("switch comment tags for real usage..")
//        UserDefaultsService.update(with: UserDefaultsService.fetchUpdated())
        UserDefaultsService.update(with: UserDefaultsService())
    }
    
    func childDidFinish(_ coordinator: Coordinator, goTo nextScene: SceneOption) {
        childCoordinators = childCoordinators.filter({ (coord) -> Bool in
            if let _ = coordinator as? HomeSceneCoordinator {
                return false
            }
            return true
        })
        switch nextScene {
        case .homeScene: goToHomeScene()
        case .settingsScene: goToSettingsScene()
        }
    }
    
    func goToHomeScene(){
        let child = HomeSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        child.start()
    }
    
    func goToSettingsScene() {
        let child = SettingsSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
}

