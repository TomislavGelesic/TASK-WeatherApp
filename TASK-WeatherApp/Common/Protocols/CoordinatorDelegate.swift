//
//  CoordinatorDelegate.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 26.02.2021..
//

import UIKit

protocol CoordinatorDelegate: class {
    func viewControllerHasFinished(goTo option: SceneOption)
}
