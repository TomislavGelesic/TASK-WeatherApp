//
//  HomeSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit

class HomeSceneCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    func start() {
        
        let viewModel = HomeSceneViewModel(coordinator: self, repository: HomeSceneRepositoryImpl())
        
        let viewController = HomeSceneViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }

    deinit {
        print("HomeSceneCoordinator deinit")
    }
    
    func goToSearchScene() {
        
        parentCoordinator?.childDidFinish(self, goTo: .searchScene)
    }
    
    func goToSettingsScene() {
        
        parentCoordinator?.childDidFinish(self, goTo: .settingsScene)
    }
}
