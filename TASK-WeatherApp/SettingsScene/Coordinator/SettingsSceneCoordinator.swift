//
//  SettingsSceneCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 18.01.2021..
//

import UIKit

class SettingsSceneCoordinator: Coordinator, CoordinatorDelegate {
    var delegate: AppCoordinator?
    var childCoordinators: [Coordinator] = .init()
    var navigationController: UINavigationController
    var backgroundImage: UIImage?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("SettingsSceneCoordinator deinit")
    }
    
    func start() {
        let viewModel = SettingsSceneViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = SettingsSceneViewController(viewModel: viewModel)
        if let image = backgroundImage {
            viewController.backgroundImage.image = image
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func viewControllerHasFinished(goTo option: SceneOption) {
        switch option {
        case .homeScene:
            navigationController.popViewController(animated: true)
            delegate?.childDidFinish(self, goTo: .homeScene)
        case .settingsScene(backgroundImage: _):
            break
        }
    }
}
