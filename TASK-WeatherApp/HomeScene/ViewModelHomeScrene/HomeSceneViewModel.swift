//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine

class HomeSceneViewModel {
    
    var cityWeatherRepository: NetworkRepository
    
    var userSettings = UserDefaultsService.fetchUpdated()
    
    var refreshUISubject = PassthroughSubject<WeatherInfo, Never>()
    
    var fetchWeatherSubject = CurrentValueSubject<Bool, Never>(true)
    
    init(repository: NetworkRepository) {
        cityWeatherRepository = repository
    }
}

extension HomeSceneViewModel {
    
    func initializeFetchWeatherSubject(subject: AnyPublisher<Bool, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<CityWeatherResponse, NetworkError> in
                
                var path = String()
                
                path.append(Constants.OpenWeatherMapORG.BASE)
                path.append(Constants.OpenWeatherMapORG.GET_CITY_BY_ID)
                path.append(userSettings.lastCityId)
                path.append(Constants.OpenWeatherMapORG.KEY)
                
                
                switch userSettings.measurmentUnit {
                case .metric:
                    path.append(Constants.OpenWeatherMapORG.WITH_METRIC_UNITS)
                    break
                case .imperial:
                    path.append(Constants.OpenWeatherMapORG.WITH_IMPERIAL_UNITS)
                    break
                }
                guard let urlPath = URL(string: path) else { fatalError("FAILED TO CREATE URL FOR WEATHER") }
                
                return self.cityWeatherRepository.getNetworkSubject(ofType: CityWeatherResponse.self, for: urlPath)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { (completion) in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            } receiveValue: { [unowned self] (response) in
                
                let weatherInfo = self.createCityWeatherItem(from: response)
                CoreDataService.sharedInstance.save(weatherInfo)
                self.refreshUISubject.send(weatherInfo)
            }

            
    }
    
    func getConditions() -> [ConditionTypes] {
        
        userSettings = UserDefaultsService.fetchUpdated()
        
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
    
    func createCityWeatherItem(from response: CityWeatherResponse) -> WeatherInfo {

        return WeatherInfo(id: String(response.id),
                               cityName: String(response.name),
                               weatherDescription: String(response.weather.description),
                               pressure: String(response.main.pressure),
                               windSpeed: String(response.wind.speed),
                               humidity: String(response.main.humidity),
                               min_Temperature: String(response.main.temp_min),
                               current_Temperature: String(response.main.temp),
                               max_Temperature: String(response.main.temp_max),
                               weatherType: String(response.weather.id)
        )
    }
}
