//
//  AppCoordinator.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit


class AppCoordinator: Coordinator {
    
    #warning("Incomplete UserSettings logic...")
    var userSettings = UserSettings()
    
    var cityWeatherRepository = CityWeatherRepository()
    
    var coreDataService: CoreDataService = CoreDataService.sharedInstance
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        
        goToHomeScene(selectedCity_id: nil)
    }
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        
        let defaults = UserDefaults.standard
        let userDefaults = UserSettings()
        defaults.set(userDefaults, forKey: "UserSettings")
        
    }
}

extension AppCoordinator {
    
    func goToHomeScene(selectedCity_id: String?){
        
        userSettings = UserDefaults.standard.object(forKey: "UserSettings") as? UserSettings ?? UserSettings()
        
        var path = String()
        
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append(Constants.OpenWeatherMapORG.GET_CITY_BY_ID)
        
        if let id = selectedCity_id {
            path.append(id)
        } else {
            path.append("2761369")
        }
        
        path.append(Constants.OpenWeatherMapORG.KEY)
        
        if userSettings.meassurmentUnit == .metric {
            path.append(Constants.OpenWeatherMapORG.WITH_METRIC_UNITS)
        } else {
            path.append(Constants.OpenWeatherMapORG.WITH_IMPERIAL_UNITS)
        }
        
        guard let urlPath = URL(string: path) else { return }
        
        var weather = CityWeatherItem()
        
        cityWeatherRepository
            .getNetworkSubject(ofType: CityWeatherResponse.self, for: urlPath)
            .sink { [unowned self] (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            } receiveValue: { [unowned self] (response) in
                
                weather = self.createCityWeatherItem(from: response)
                
            }.cancel()
        
        
        childCoordinators.removeAll()
        
        navigationController.popViewController(animated: false)
        
        let child = HomeSceneCoordinator(parentCoordinator: self, navigationController: navigationController, weather: weather)
        
        childCoordinators.append(child)
        
        child.start()
        
    }
    
    func goToSearchScene() {
        
        childCoordinators.removeAll()
        
        navigationController.popViewController(animated: false)
        
        let child = SearchSceneCoordinator(parentCoordinator: self, navigationController: navigationController)
        
        childCoordinators.append(child)
        
        child.start()
    }
    
    func createCityWeatherItem(from response: CityWeatherResponse) -> CityWeatherItem {
        
        return CityWeatherItem(id: response.id, name: response.name, pressure: response.main.pressure, windSpeed: response.wind.speed, humidity: response.main.humidity)
    }
    
}

