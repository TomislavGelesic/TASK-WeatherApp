//
//  HomeSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit

class HomeSceneCoordinator: Coordinator {
    
    var parentCoordinator: AppCoordinator
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    func start() {
        
        let viewModel = HomeSceneViewModel(repository: CityWeatherRepositoryImpl())
        
        let viewController = HomeSceneViewController(coordinator: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }

    func goToSearchScene() {
        
        parentCoordinator.goToSearchScene()
    }
    
    func goToSettingsScene() {
        
        parentCoordinator.goToSettingsScene()
    }
}
