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
    
    var weather: WeatherInfo
    
    func start() {
        
        let viewModel = HomeSceneViewModel(weatherInfo: weather)
        
        let viewController = HomeSceneViewController(coordinator: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController, weather: WeatherInfo) {
        
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.weather = weather
    }

    func goToSearchScene() {
        
        parentCoordinator.goToSearchScene()
    }
}
