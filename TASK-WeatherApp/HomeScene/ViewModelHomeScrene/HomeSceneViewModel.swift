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
    
    var getCityIdForLocation = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    
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
                return self.homeSceneRepositoryImpl.fetchWeatherData(id: UserDefaultsService.fetchUpdated().lastCityId)
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
                    switch error {
                    case .noDataError:
                        self.alertSubject.send("There is no weather data for this city, yet!\nTry another one.")
                    default:
                        self.alertSubject.send("Error occured requesting weather data for this city!\nSearch for another one.")
                    }
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
                
                var search = ""
                
                if let safeCoordinate = coordinate,
                   UserDefaultsService.fetchUpdated().shouldShowUserLocationWeather {
                    
                    search = "lat=\(safeCoordinate.latitude)&lng=\(safeCoordinate.longitude)"
                    return self.homeSceneRepositoryImpl.fetchSearchResult(for: search)
                }
                else {
                    
                    search = Constants.DEFAULT_VIENNA_LATITUDE_LONGITUDE
                    return self.homeSceneRepositoryImpl.fetchSearchResult(for: search)
                }
            })
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { (completion) in
                
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    print("im here")
                    break
                }
            } receiveValue: { [unowned self] (response) in
                
                if let item = response.geonames.first {
                    
                    UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                                           lastCityId: String(item.geonameId),
                                                           shouldShowWindSpeed: nil,
                                                           shouldShowPressure: nil,
                                                           shouldShowHumidity: nil)
                    CoreDataService.sharedInstance.save(item)
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
