//
//  AppCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit


class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        
        goToHomeScene()
    }
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
}

extension AppCoordinator {
    
    func goToHomeScene(){
            
            childCoordinators.removeAll()
        
            let child = HomeSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
            
            childCoordinators.append(child)
            
            child.start()
        
    }
    
    func goToSearchScene() {
        
        childCoordinators.removeAll()
        
        let child = SearchSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
}

