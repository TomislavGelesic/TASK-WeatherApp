//
//  CityWeatherRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import Combine

class WeatherRepositoryImpl: Repository {
    
    func fetchNewData() -> AnyPublisher<WeatherResponse, NetworkError> {
        
        var path = String()
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append(Constants.OpenWeatherMapORG.GET_CITY_BY_ID)
        path.append(UserDefaultsService.fetchUpdated().lastCityId)
        path.append(Constants.OpenWeatherMapORG.KEY)
        
        switch UserDefaultsService.fetchUpdated().measurmentUnit {
        case .metric:
            path.append(Constants.OpenWeatherMapORG.WITH_METRIC_UNITS)
            break
        case .imperial:
            path.append(Constants.OpenWeatherMapORG.WITH_IMPERIAL_UNITS)
            break
        }
        guard let urlPath = URL(string: path) else { fatalError("FAILED TO CREATE URL FOR WEATHER") }
        
        
        return NetworkService().fetchData(for: urlPath)
    }
    
    func getConditions() -> [ConditionTypes] {
            
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

