//
//  Repository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 29.01.2021..
//

import Foundation
import Combine

protocol Repository {
    
    func getCurrentWeather() -> AnyPublisher<WeatherResponse, NetworkError> 
    
}
