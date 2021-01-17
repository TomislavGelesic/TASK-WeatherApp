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
    
    var savedCities:
    
    var userSettings: UserSettings
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    init(savedCities: ) {
        userSettings = UserSettings(meassurmentUnit: <#T##MeassurmentUnits#>,
                                    lastCityId: <#T##String#>,
                                    shouldShowWindSpeed: <#T##Bool#>,
                                    shouldShowPressure: <#T##Bool#>,
                                    shouldShowHumidity: <#T##Bool#>)
    }
}

extension SettingsSceneViewModel {
    
    func saveUserSettings() {
        
        let userDefaults = UserDefaults.standard
        
        switch userSettings.meassurmentUnit {
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
