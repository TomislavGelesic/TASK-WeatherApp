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
    var weatherSubject = CurrentValueSubject<CLLocationCoordinate2D, Never>(Constants.DEFAULT_LOCATION)
    var screenData = WeatherInfo()
    var coreDataService = CoreDataService.sharedInstance
    
    init(coordinator coord: HomeSceneCoordinator, repository: HomeSceneRepositoryImpl) {
        coordinator = coord
        homeSceneRepositoryImpl = repository
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
    
    func initializeWeatherSubject(subject: AnyPublisher<CLLocationCoordinate2D, Never>) -> AnyCancellable {
        
        return subject
            .flatMap({ [unowned self] (coordinate) -> AnyPublisher<WeatherInfo, Never> in
                self.spinnerSubject.send(true)
                return homeSceneRepositoryImpl.fetchWeatherDataBy(location: coordinate)
                    .flatMap { [unowned self] (result) -> AnyPublisher<WeatherInfo, Never> in
                        switch result {
                        case .success(let weatherResponse):
                            return Just(WeatherInfo(weatherResponse)).eraseToAnyPublisher()
                        case .failure(_):
                            self.spinnerSubject.send(false)
                            self.alertSubject.send("Internet connection lost.")
                            return Just(WeatherInfo()).eraseToAnyPublisher()
                        }
                    }.eraseToAnyPublisher()
            })
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { (completion) in
                switch completion {
                case .finished: break
                case .failure(_): print("THIS ERROR SHOULD NEVER HAPPEN")
                }
            } receiveValue: { [unowned self] (data) in
                self.screenData = data
                UserDefaultsService.update(with: data)
                self.coreDataService.save(data)
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
    
    func getMeasurementUnit() -> MeasurementUnits { return UserDefaultsService.fetchUpdated().measurmentUnit }
    
    func settingsTapped(image: UIImage) { coordinator.goToSettingsScene(image: image) }
    
    func updateBackgorundImageInfo(weatherType: String, daytime: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(daytime, forKey: Constants.UserDefaults.IS_DAY_TIME)
    }
    
    func shouldShowUserLocation() -> Bool { return UserDefaultsService.fetchUpdated().shouldShowUserLocationWeather }
    
    func isDayTime() -> Bool { screenData.daytime }
    
    func update(_ item: Geoname) {
        coreDataService.save(item)
        UserDefaultsService.update(with: item)
        let settings = UserDefaultsService.fetchUpdated()
        weatherSubject.send(CLLocationCoordinate2D(latitude: settings.lastLatitude, longitude: settings.lastLongitude))
    }
}
