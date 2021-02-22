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
        
    }
    
    init(parentCoordinator: AppCoordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    deinit {
//        print("SearchSceneCoordinator deinit")
    }
    
    func goToHomeScene() {
        navigationController.dismiss(animated: true, completion: nil)
        parentCoordinator.childDidFinish(self, goTo: .homeScene)
    }
}
