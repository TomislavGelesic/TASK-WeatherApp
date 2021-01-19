//
//  SearchSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit

class SearchSceneCoordinator: Coordinator {
    
    var parentCoordinator: AppCoordinator
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    func start() {
        
        let viewModel = SearchSceneViewModel(searchRepository: SearchRepositoryImpl())
        
        let viewController = SearchSceneViewController(coordinator: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func goToHomeScene() {
        
        parentCoordinator.goToHomeScene()
    }
}
