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
    
    var coordinator: HomeSceneCoordinator
    
    var homeSceneRepositoryImpl: HomeSceneRepositoryImpl
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var getCityIdForLocation = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    
    var fetchWeather = PassthroughSubject<Void, Never>()
    
    var screenData = WeatherInfo()
    
    init(coordinator coord: HomeSceneCoordinator, repository: HomeSceneRepositoryImpl) {
        coordinator = coord
        homeSceneRepositoryImpl = repository
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
    
    func initializeScreenData(for subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        return subject
            .flatMap {[unowned self] (_) -> AnyPublisher<WeatherResponse, NetworkError> in
                self.spinnerSubject.send(true)
                return self.homeSceneRepositoryImpl.fetchWeatherDataBy(id: UserDefaultsService.fetchUpdated().lastCityId)
            }
            .map({ WeatherInfo($0) })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
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
                self.updateBackgorundImageInfo(weatherType: data.weatherType, daytime: data.daytime)
                self.refreshUISubject.send()
                self.spinnerSubject.send(false)
            })
    }
    
    func initializeLocationSubject(subject: AnyPublisher<CLLocationCoordinate2D?, Never>) -> AnyCancellable {
            
            return subject
                .flatMap({ [unowned self] (coordinate) -> AnyPublisher<WeatherResponse, NetworkError> in
                    if let safeCoordinate = coordinate {
                        
                        return homeSceneRepositoryImpl.fetchWeatherDataBy(location: safeCoordinate)
                    }
                    else {
                        let defaultLocation = CLLocationCoordinate2D(latitude: Constants.DEFAULT_LATITUDE,
                                                                     longitude: Constants.DEFAULT_LONGITUDE)
                        return homeSceneRepositoryImpl.fetchWeatherDataBy(location: defaultLocation)
                    }
                })
                .map({ WeatherInfo($0) })
                .receive(on: RunLoop.main)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { (completion) in
                    
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        print("im here")
                        break
                    }
                } receiveValue: { [unowned self] (data) in
                    self.screenData = data
                    self.updateBackgorundImageInfo(weatherType: data.weatherType, daytime: data.daytime)
                    self.refreshUISubject.send()
                    self.spinnerSubject.send(false)
                }
        }
    
    func getConditionsToShow() -> [ConditionTypes] {
        let userSettings = UserDefaultsService.fetchUpdated()
        var conditions = [ConditionTypes]()
        if userSettings.shouldShowHumidity { conditions.append(.humidity) }
        if userSettings.shouldShowPressure { conditions.append(.pressure) }
        if userSettings.shouldShowWindSpeed { conditions.append(.windSpeed) }
        return conditions
    }
    
    func getUserSettings() -> UserDefaultsService { return UserDefaultsService.fetchUpdated() }
    
    func settingsTapped() { coordinator.goToSettingsScene() }
    
    func searchTapped() { coordinator.goToSearchScene() }
    
    func updateBackgorundImageInfo(weatherType: String, daytime: Bool) {

        let userDefaults = UserDefaults.standard

        userDefaults.setValue(weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(daytime, forKey: Constants.UserDefaults.IS_DAY_TIME)
    }
}
