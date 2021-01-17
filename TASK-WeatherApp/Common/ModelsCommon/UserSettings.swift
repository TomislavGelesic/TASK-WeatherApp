//
//  UserSettings.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation

class UserSettings {
    
    var meassurmentUnit: MeassurmentUnits = .metric
    var lastCityId: String = "2761369"                      // Vienna id
    var shouldShowWindSpeed: Bool = false
    var shouldShowPressure: Bool = false
    var shouldShowHumidity: Bool = false
    
    init(meassurmentUnit: MeassurmentUnits = .metric, lastCityId: String = "2761369", shouldShowWindSpeed: Bool = false, shouldShowPressure: Bool = false, shouldShowHumidity: Bool = false) {
        self.meassurmentUnit = meassurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
    }
    
    
    
}

extension UserSettings {
    
    static func getNewestUserSettings() -> UserSettings {
        let userDefaults = UserDefaults.standard
        
        var unitType: MeassurmentUnits = .metric
        
        if let type = userDefaults.value(forKey: "meassurmentUnit") as? String {
            switch type {
            case "metric":
                unitType = .metric
            default:
                unitType = .imperial
            }
        }
        
        return UserSettings(
            meassurmentUnit: userDefaults.value(forKey: "meassurmentUnit") as? String ?? .metric,
            lastCityId: <#T##String#>,
            shouldShowWindSpeed: <#T##Bool#>,
            shouldShowPressure: <#T##Bool#>,
            shouldShowHumidity: <#T##Bool#>)
    }
}
