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
    
    func initializeUserSettings() { UserDefaultsService.update(with: UserDefaultsService.fetchUpdated()) }
    
    func childDidFinish(_ coordinator: Coordinator, goTo nextScene: SceneOption) {
        childCoordinators = childCoordinators.filter({ (coord) -> Bool in
            if let _ = coordinator as? HomeSceneCoordinator { return false }
            else { return true }
        })
        switch nextScene {
        case .homeScene: break
        case .settingsScene(let image): goToSettingsScene(image: image)
        }
    }
    
    func goToHomeScene(){
        let child = HomeSceneCoordinator(navigationController: navigationController)
        child.delegate = self
        child.start()
    }
    
    func goToSettingsScene(image: UIImage) {
        let child = SettingsSceneCoordinator(navigationController: navigationController)
        child.delegate = self
        childCoordinators.append(child)
        child.backgroundImage = image
        child.start()
    }
}

