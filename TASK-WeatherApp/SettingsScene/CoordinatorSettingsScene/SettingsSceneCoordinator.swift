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
}

extension SettingsSceneCoordinator {
    
    func start() {
        
        let subNavigationController = UINavigationController(rootViewController: SettingsSceneViewController(coordinator: self,
                                                                                                             viewModel: SettingsSceneViewModel()
        ))
        
        subNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(subNavigationController, animated: true)
        
    }
    
    func returnToHomeScene() {
        
        navigationController.dismiss(animated: true, completion: nil)
        parentCoordinator.goToHomeScene()
    }
}
