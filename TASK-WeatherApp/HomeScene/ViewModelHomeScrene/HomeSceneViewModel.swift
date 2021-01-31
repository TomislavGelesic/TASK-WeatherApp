//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine

class HomeSceneViewModel {
    
    var weatherRepository: WeatherRepositoryImpl
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var getData = PassthroughSubject<Void, Never>()

    var disposeBag = Set<AnyCancellable>()
    
    init(repository: WeatherRepositoryImpl) {
        
        weatherRepository = repository
        
        setSubscribers()
        
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
}

extension HomeSceneViewModel {
    
    func setSubscribers() {
        
        weatherRepository.initializeWeatherInfo(with: weatherRepository.getData.eraseToAnyPublisher())
            .store(in: &disposeBag)
    }
    
    func getConditionsToShow() -> [ConditionTypes] {
        
        return weatherRepository.getWantedConditions()
    }
    
}
