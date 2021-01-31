//
//  SettingsRepositoryImpl.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 31.01.2021..
//

import UIKit
import Combine

class SettingsRepositoryImpl: Repository {
    
    typealias T = [WeatherInfo]
    
    var repositoryChanged: PassthroughSubject<[WeatherInfo], RepositoryError> = .init()
    
    var getData: CurrentValueSubject<Bool, Never> = .init(true)
    
    var data: [WeatherInfo] = .init()
    
    var savedSettings = UserDefaultsService.fetchUpdated()
    
    var coreData = CoreDataService.sharedInstance
    
}
