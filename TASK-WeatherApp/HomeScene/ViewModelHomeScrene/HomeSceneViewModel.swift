//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import MapKit

class HomeSceneViewModel {
    
    var homeSceneRepositoryImpl: HomeSceneRepositoryImpl
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var getNewScreenData = PassthroughSubject<Void, Never>()
    
    var getCityIdForLocation = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    
    var screenData = WeatherInfo()
    
    init(repository: HomeSceneRepositoryImpl) {
        
        homeSceneRepositoryImpl = repository
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
}

extension HomeSceneViewModel {
    
    func initializeScreenData(for subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        return subject
            .flatMap {[unowned self] (_) -> AnyPublisher<WeatherResponse, NetworkError> in
                self.spinnerSubject.send(true)
                return self.homeSceneRepositoryImpl.fetchNewData()
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
                    print(error)
                    self.alertSubject.send("Error connecting to 'openweather.org' service.")
                }
            }, receiveValue: {[unowned self] data in
                self.screenData = data
                self.refreshUISubject.send()
                self.spinnerSubject.send(false)
            })
    }
    
    func initializeLocationSubject(subject: AnyPublisher<CLLocationCoordinate2D?, Never>) -> AnyCancellable {
        
        return subject
            .flatMap({ [unowned self] (coordinate) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                if let safeCoordinate = coordinate {
                    let search = "lat=\(safeCoordinate.latitude)&lng=\(safeCoordinate.longitude)"
                    print("lat=\(safeCoordinate.latitude)&lng=\(safeCoordinate.longitude)")
                    self.homeSceneRepositoryImpl.fetchSearchResult(for: search)
                        .receive(on: RunLoop.main)
                        .subscribe(on: RunLoop.main)
                        .sink { (completion) in
                        } receiveValue: { (response) in
                            
                            if let id = response.geonames.first?.geonameId {
                                
                                UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                                                       lastCityId: String(id),
                                                                       shouldShowWindSpeed: nil,
                                                                       shouldShowPressure: nil,
                                                                       shouldShowHumidity: nil)
                            }
                        }.cancel()

                }
                let search = "lat=48.210033&lng=16.363449)"
                return self.homeSceneRepositoryImpl.fetchSearchResult(for: search)
            
            })
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { (completion) in
                
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    
                    break
                }
            } receiveValue: { [unowned self] (response) in
                
                if let id = response.geonames.first?.geonameId {
                    
                    UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                                           lastCityId: String(id),
                                                           shouldShowWindSpeed: nil,
                                                           shouldShowPressure: nil,
                                                           shouldShowHumidity: nil)
                    self.getNewScreenData.send()
                }
            }
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
    
    func getUserSettings() -> UserDefaultsService {
        
        return UserDefaultsService.fetchUpdated()
    }
    
    
    
}
