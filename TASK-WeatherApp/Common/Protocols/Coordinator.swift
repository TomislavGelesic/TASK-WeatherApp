//
//  Coordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { set get }
    
    var navigationController: UINavigationController { set get }
    
    func start()
    
}
