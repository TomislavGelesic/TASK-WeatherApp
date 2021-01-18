//
//  SettingsSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import SnapKit

class SettingsSceneViewModel {
    
    var savedLocations = [CityWeather]()
    
    var coreDataService = CoreDataService.sharedInstance
    
    var userSettings = UserDefaultsService.fetchUpdated()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    init() {
        
        if let cities = coreDataService.get(.all) {
            savedLocations = cities
        }
    }
}

extension SettingsSceneViewModel {
    
    func remove(at position: Int) {
        
        let id = savedLocations[position].id
        savedLocations.remove(at: position)
        coreDataService.delete(id)
        refreshUISubject.send()
    }
    
    func saveUserSettings() {
        
        let userDefaults = UserDefaults.standard
        
        switch userSettings.measurmentUnit {
        case .imperial:
            userDefaults.setValue(true, forKey: "imperial")
            break
        case .metric:
            userDefaults.setValue(true, forKey: "metric")
            break
        }
        userDefaults.setValue(userSettings.shouldShowPressure, forKey: "pressure")
        userDefaults.setValue(userSettings.shouldShowHumidity, forKey: "humidity")
        userDefaults.setValue(userSettings.shouldShowWindSpeed, forKey: "windSpeed")
        
    }
}
