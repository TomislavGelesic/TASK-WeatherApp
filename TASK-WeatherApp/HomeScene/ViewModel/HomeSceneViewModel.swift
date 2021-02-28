//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import MapKit
import Alamofire

class HomeSceneViewModel {
    
    var coordinatorDelegate: CoordinatorDelegate?
    var homeSceneRepositoryImpl: HomeSceneRepositoryImpl
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    var alertSubject = PassthroughSubject<String, Never>()
    var refreshUISubject = PassthroughSubject<Void, Never>()
    var weatherSubject = CurrentValueSubject<CLLocationCoordinate2D, Never>(Constants.DEFAULT_LOCATION)
    var screenData = WeatherInfo()
    var coreDataService = CoreDataService.sharedInstance
    
    init(repository: HomeSceneRepositoryImpl) {
        homeSceneRepositoryImpl = repository
    }
    
    deinit {
        print("HomeSceneViewModel deinit")
    }
    
    func initializeWeatherSubject(subject: AnyPublisher<CLLocationCoordinate2D, Never>) -> AnyCancellable {
        
        return subject
            .flatMap({ [unowned self] (coordinate) -> AnyPublisher<Result<WeatherResponse, AFError>, Never> in
                self.spinnerSubject.send(true)
                return homeSceneRepositoryImpl.fetchWeatherDataBy(location: coordinate)
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (result) in
                switch result {
                case .success(let response):
                    let data = WeatherInfo(response)
                    self.screenData = data
                    UserDefaultsService.update(with: data)
                    self.coreDataService.save(data)
                    self.refreshUISubject.send()
                    self.spinnerSubject.send(false)
                case .failure(let error):
                    print(error)
                    self.spinnerSubject.send(false)
                    self.alertSubject.send("Internet connection lost.")
                }
            })
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
    
    func settingsTapped(image: UIImage) {
        coordinatorDelegate?.viewControllerHasFinished(goTo: .settingsScene(backgroundImage: image))
    }
    
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
    
    func presentSearchScene(on vc: HomeSceneViewController?, with image: UIImage?) {
        if let vc = vc {
            let vm = SearchSceneViewModel(searchRepository: SearchRepositoryImpl())
            vm.delegate = vc
            let viewController = SearchSceneViewController(viewModel: vm)
            viewController.backgroundImage.image = image
            viewController.modalPresentationStyle = .fullScreen
            vc.present(vc, animated: true)
        }
    }
}
