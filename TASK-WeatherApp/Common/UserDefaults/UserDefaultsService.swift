//
//  UserDefaultsService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import Combine

class UserDefaultsService {
    
    var measurmentUnit: MeasurementUnits = .metric
    var lastCityId: String = "2761369"                      // Vienna id
    var shouldShowWindSpeed: Bool = false
    var shouldShowPressure: Bool = false
    var shouldShowHumidity: Bool = false
    var weatherType: Int = 800
    var dayTime: Bool = true
    
    init(measurmentUnit: MeasurementUnits = .metric, lastCityId: String = "2761369", shouldShowWindSpeed: Bool = false, shouldShowPressure: Bool = false, shouldShowHumidity: Bool = false, weatherType: Int = 800, dayTime: Bool = true) {
        self.measurmentUnit = measurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
        self.weatherType = weatherType
        self.dayTime = dayTime
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
            #warning("print delete")
            print("saving lastCityID as \(value)")
        }
        
        if let value = shouldShowPressure {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE)
            #warning("print delete")
            print("saving pressure as \(value)")
        }
        
        if let value = shouldShowHumidity {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY)
            #warning("print delete")
            print("saving humidity as \(value)")
        }
        
        if let value = shouldShowWindSpeed {
            userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED)
            #warning("print delete")
            print("saving windSpeed as \(value)")
        }
    }
    
    static func updateBackgorundImage(weatherType: Int, daytime: Bool) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(daytime, forKey: Constants.UserDefaults.IS_DAY_TIME)
    }
    
    static func getBackgroundImage() -> UIImage? {
        
        let userSettings = UserDefaultsService.fetchUpdated()
        let weatherType = userSettings.weatherType
        let dayTime = userSettings.dayTime
        
        switch weatherType {
        // Thunderstorm
        case 200..<300:
            return UIImage(named: "body_image-thunderstorm")
        // Drizzle & Rain
        case 300..<600:
            return UIImage(named: "body_image-rain")
            
        // Snow
        case 600..<700:
            return UIImage(named: "body_image-snow")
            
        // Atmosphere
        case 700..<800:
            if weatherType == 741 {
                return UIImage(named: "body_image-fog")
            }
            if weatherType == 781 {
                return UIImage(named: "body_image-tornado")
            }
           return UIImage(named: "body_image-fog")
        // Clouds
        case 801..<810:
            if dayTime {
                return UIImage(named: "body_image-partly-cloudy-day")
            }
            return UIImage(named: "body_image-partly-cloudy-night")
            
        // Clear == 800, or others - currently don't exist on server
        default:
            if dayTime {
                return UIImage(named: "body_image-clear-day")
            }
            return UIImage(named: "body_image-clear-night")
        }
    }
}
