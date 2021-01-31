//
//  CityWeatherRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import Combine

class WeatherRepositoryImpl: Repository {
    
    
    typealias T = WeatherInfo
    
    var userSettings = UserDefaultsService.fetchUpdated()
    var coreData = CoreDataService.sharedInstance
    var data: WeatherInfo = .init()
    
    var getData: CurrentValueSubject<Bool, Never> = .init(true)
    
    var repositoryChanged: PassthroughSubject<WeatherInfo, RepositoryError> = .init()
    
    func initializeWeatherInfo(with subject: AnyPublisher<Bool, Never>) -> AnyCancellable {
        
        var path = String()
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append(Constants.OpenWeatherMapORG.GET_CITY_BY_ID)
        path.append(userSettings.lastCityId)
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
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<WeatherResponse, NetworkError> in
                return NetworkService().fetchData(for: urlPath)
            }
            .map({ [unowned self] (response) in
               
                return self.createWeatherInfo(from: response)
            })
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
            } receiveValue: { [unowned self] (data) in
                self.data = data
                self.repositoryChanged.send(data)
            }
    }
    
    func getWantedConditions() -> [ConditionTypes] {
        
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
    
    func createWeatherInfo(from response: WeatherResponse) -> WeatherInfo {

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
