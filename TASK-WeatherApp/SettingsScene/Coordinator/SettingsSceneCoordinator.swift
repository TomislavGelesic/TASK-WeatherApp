//
//  SettingsSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 18.01.2021..
//

import UIKit

class SettingsSceneCoordinator: Coordinator {
    
    var parentCoordinator: AppCoordinator
    var childCoordinators: [Coordinator] = .init()
    var navigationController: UINavigationController
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    deinit {
//        print("SettingsSceneCoordinator deinit")
    }
}

extension SettingsSceneCoordinator {
    
    func start() {
        let viewController = SettingsSceneViewController(viewModel: SettingsSceneViewModel(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func returnToHomeScene() { parentCoordinator.childDidFinish(self, goTo: .homeScene) }
}
