//
//  UserDefaultsService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation
import Combine

class UserDefaultsService {
    
    var measurmentUnit: MeasurementUnits = .metric
    var lastCityId: String = "2761369"                      // Vienna id
    var shouldShowWindSpeed: Bool = false
    var shouldShowPressure: Bool = false
    var shouldShowHumidity: Bool = false
    
    init(measurmentUnit: MeasurementUnits = .metric, lastCityId: String = "2761369", shouldShowWindSpeed: Bool = false, shouldShowPressure: Bool = false, shouldShowHumidity: Bool = false) {
        self.measurmentUnit = measurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
    }
}

extension UserDefaultsService {
    
    static func fetchUpdated() -> UserDefaultsService {
        
        let userDefaults = UserDefaults.standard
        let userSettings = UserDefaultsService()
        
        if let type = userDefaults.value(forKey: Constants.UserDefaults.MEASURMENT_UNIT) as? String {
            switch type {
            case "imperial":
                userSettings.measurmentUnit = .imperial
            default:
                userSettings.measurmentUnit = .metric
            }
        }
        
        if let cityID = userDefaults.value(forKey: Constants.UserDefaults.CITY_ID) as? String {
            userSettings.lastCityId = cityID
        }
        
        if let should = userDefaults.value(forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY) as? Bool {
            userSettings.shouldShowHumidity = should
        }
        
        if let should = userDefaults.value(forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED) as? Bool {
            userSettings.shouldShowWindSpeed = should
        }
        
        if let should = userDefaults.value(forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE) as? Bool {
            userSettings.shouldShowPressure = should
        }
        
        return userSettings
    }
    
    static func updateUserSettings(measurmentUnit: MeasurementUnits? = nil, lastCityId: String? = nil, shouldShowWindSpeed: Bool? = nil, shouldShowPressure: Bool? = nil, shouldShowHumidity: Bool? = nil) {
        
        let userDefaults = UserDefaults.standard
        
        if let value = measurmentUnit {
            switch value {
            case .imperial:
                userDefaults.setValue("imperial", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
            default:
                userDefaults.setValue("metric", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
            }
        }
        
        if let value = lastCityId {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.CITY_ID)
        }
        
        if let value = shouldShowPressure {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE)
        }
        
        if let value = shouldShowHumidity {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY)
        }
        
        if let value = shouldShowWindSpeed {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED)
        }
    }
    
    static func getSubject() -> AnyPublisher<UserDefaultsService, Never> {
        return CurrentValueSubject<UserDefaultsService, Never>(UserDefaultsService.fetchUpdated()).eraseToAnyPublisher()
    }
}
