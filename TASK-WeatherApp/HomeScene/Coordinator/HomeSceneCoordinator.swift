//
//  HomeSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit

class HomeSceneCoordinator: Coordinator, CoordinatorDelegate {
    
    weak var delegate: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        print("HomeSceneCoordinator deinit")
    }
    
    func start() {
        let viewModel = HomeSceneViewModel(repository: HomeSceneRepositoryImpl())
        viewModel.coordinatorDelegate = self
        if viewModel.coordinatorDelegate != nil {
            print("ok")
        }
        let viewController = HomeSceneViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func viewControllerHasFinished(goTo option: SceneOption) {
        switch option {
        case .homeScene:
            break
        case .settingsScene(backgroundImage: let image):
            navigationController.popViewController(animated: true)
            delegate?.childDidFinish(self, goTo: .settingsScene(backgroundImage: image))
        }
    }
}

