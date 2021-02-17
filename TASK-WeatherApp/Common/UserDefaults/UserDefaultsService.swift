//
//  UserDefaultsService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import Combine

class UserDefaultsService {
    
    var measurmentUnit: MeasurementUnits
    var lastCityId: String
    var shouldShowWindSpeed: Bool
    var shouldShowPressure: Bool
    var shouldShowHumidity: Bool
    var weatherType: Int
    var dayTime: Bool
    var shouldShowUserLocationWeather: Bool
    
    init(measurmentUnit: MeasurementUnits = .metric, lastCityId: String = Constants.DEFAULT_CITY_ID, shouldShowWindSpeed: Bool = false, shouldShowPressure: Bool = false, shouldShowHumidity: Bool = false, weatherType: Int = 800, dayTime: Bool = true, shouldShowUserLocationWeather: Bool = true) {
        self.measurmentUnit = measurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
        self.weatherType = weatherType
        self.dayTime = dayTime
        self.shouldShowUserLocationWeather = shouldShowUserLocationWeather
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
        
        if let weatherType = userDefaults.value(forKey: Constants.UserDefaults.WEATHER_TYPE) as? Int {
            userSettings.weatherType = weatherType
        }
        
        if let dayTime = userDefaults.value(forKey: Constants.UserDefaults.IS_DAY_TIME) as? Bool {
            userSettings.dayTime = dayTime
        }
        
        if let status = userDefaults.value(forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER) as? Bool {
            userSettings.shouldShowUserLocationWeather = status
        }
        
        return userSettings
    }
    
    static func updateUserSettings(measurmentUnit: MeasurementUnits? = nil,
                                   lastCityId: String? = nil,
                                   shouldShowWindSpeed: Bool? = nil,
                                   shouldShowPressure: Bool? = nil,
                                   shouldShowHumidity: Bool? = nil,
                                   dayTime: Bool? = nil,
                                   weatherType: Int? = nil) {
        
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
        
        if let value = weatherType {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.WEATHER_TYPE)
        }
        
        if let value = dayTime {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.IS_DAY_TIME)
        }
    }
    
    static func setShouldShowUserLocationWeather (_ value: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER)
    }
}
