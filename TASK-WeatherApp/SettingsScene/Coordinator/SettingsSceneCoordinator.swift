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
    var backgroundImage: UIImage?
    
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
        if let image = backgroundImage {
            viewController.backgroundImage.image = image
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func returnToHomeScene() {
        navigationController.popViewController(animated: true)
        parentCoordinator.childDidFinish(self, goTo: .homeScene)
    }
}
