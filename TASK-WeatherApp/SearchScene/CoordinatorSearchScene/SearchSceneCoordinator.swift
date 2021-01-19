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
        
        let subNavigationController = UINavigationController(rootViewController: viewController)
        
        subNavigationController.modalPresentationStyle = .fullScreen
        
        navigationController.present(subNavigationController, animated: true)
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func goToHomeScene() {
        
        navigationController.dismiss(animated: true, completion: nil)
        
        parentCoordinator.goToHomeScene()
    }
}
