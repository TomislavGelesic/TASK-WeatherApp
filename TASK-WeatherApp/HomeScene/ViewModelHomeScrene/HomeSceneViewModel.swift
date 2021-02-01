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
    
    var getNewScreenData = CurrentValueSubject<Bool, Never>(true)
    
    var screenData = WeatherInfo()
    
    init(repository: WeatherRepositoryImpl) {
        
        weatherRepository = repository
        
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
}

extension HomeSceneViewModel {
    
    func initializeScreenData(for subject: AnyPublisher<Bool, Never>) -> AnyCancellable {
        
        return subject
            .flatMap {[unowned self] (_) -> AnyPublisher<WeatherResponse, NetworkError> in
                self.spinnerSubject.send(true)
                return self.weatherRepository.getCurrentWeather()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [unowned self] (weatherResponse) -> WeatherInfo in
                return self.createCityWeatherItem(from: weatherResponse)
            })
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.alertSubject.send(error.localizedDescription)
                }
            }, receiveValue: {[unowned self] data in
                self.screenData = data
                self.refreshUISubject.send()
                self.spinnerSubject.send(false)
            })
    }
    
    func createCityWeatherItem(from response: WeatherResponse) -> WeatherInfo {
        
        return WeatherInfo(id:                      String(response.id),
                           cityName:                String(response.name),
                           weatherDescription:      String(response.weather.description),
                           pressure:                String(response.main.pressure),
                           windSpeed:               String(response.wind.speed),
                           humidity:                String(response.main.humidity),
                           min_Temperature:         String(response.main.temp_min),
                           current_Temperature:     String(response.main.temp),
                           max_Temperature:         String(response.main.temp_max),
                           weatherType:             String(response.weather.id),
                           daytime:                 response.weather.icon.suffix(1) == "d" ? true : false
        )
    }
    
    func getConditionsToShow() -> [ConditionTypes] {
        
        let userSettings = UserDefaultsService.fetchUpdated()
        
        var conditions = [ConditionTypes]()
        
        if userSettings.shouldShowHumidity {
            conditions.append(.humidity)
        }
        
        if userSettings.shouldShowPressure {
            conditions.append(.pressure)
        }
        
        if userSettings.shouldShowWindSpeed {
            conditions.append(.windSpeed)
        }
        
        return conditions
    }
}
