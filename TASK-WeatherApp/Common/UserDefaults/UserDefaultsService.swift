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
    var lastCityId: Int64
    var lastLatitude: Double
    var lastLongitude: Double
    var shouldShowWindSpeed: Bool
    var shouldShowPressure: Bool
    var shouldShowHumidity: Bool
    var weatherType: Int
    var dayTime: Bool
    var shouldShowUserLocationWeather: Bool
    
    init(measurmentUnit: MeasurementUnits = .metric,
         lastCityId: Int64 = Constants.DEFAULT_CITY_ID,
         shouldShowWindSpeed: Bool = false,
         shouldShowPressure: Bool = false,
         shouldShowHumidity: Bool = false,
         weatherType: Int = 800,
         dayTime: Bool = true,
         shouldShowUserLocationWeather: Bool = true,
         latitude: Double = Constants.DEFAULT_LATITUDE,
         longitude: Double = Constants.DEFAULT_LONGITUDE) {
        
        self.measurmentUnit = measurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
        self.weatherType = weatherType
        self.dayTime = dayTime
        self.shouldShowUserLocationWeather = shouldShowUserLocationWeather
        self.lastLatitude = latitude
        self.lastLongitude = longitude
    }
}

extension UserDefaultsService {
    
    static func fetchUpdated() -> UserDefaultsService {
        
        let userDefaults = UserDefaults.standard
        let userSettings = UserDefaultsService()
        
        if let type = userDefaults.value(forKey: Constants.UserDefaults.MEASURMENT_UNIT) as? String {
            switch type {
            case "imperial": userSettings.measurmentUnit = .imperial
            default: userSettings.measurmentUnit = .metric
            }
        }
        
        if let cityID = userDefaults.value(forKey: Constants.UserDefaults.LAST_CITY_ID) as? Int64 {
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
        
        if let latitude = userDefaults.value(forKey: Constants.UserDefaults.LAST_LATITUDE) as? Double {
            userSettings.lastLatitude = latitude
        }
        
        if let longitude = userDefaults.value(forKey: Constants.UserDefaults.LAST_LONGITUDE) as? Double {
            userSettings.lastLongitude = longitude
        }
        return userSettings
    }
    
    static func update(with userSettings: UserDefaultsService) {
        let userDefaults = UserDefaults.standard
        switch userSettings.measurmentUnit {
        case .imperial: userDefaults.setValue("imperial", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
        default: userDefaults.setValue("metric", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
        }
        userDefaults.setValue(userSettings.lastCityId, forKey: Constants.UserDefaults.LAST_CITY_ID)
        userDefaults.setValue(userSettings.shouldShowPressure, forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE)
        userDefaults.setValue(userSettings.shouldShowHumidity, forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY)
        userDefaults.setValue(userSettings.shouldShowWindSpeed, forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED)
        userDefaults.setValue(userSettings.weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(userSettings.dayTime, forKey: Constants.UserDefaults.IS_DAY_TIME)
        userDefaults.setValue(userSettings.lastLongitude, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(userSettings.lastLatitude, forKey: Constants.UserDefaults.LAST_LATITUDE)
        userDefaults.setValue(userSettings.shouldShowUserLocationWeather, forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER)
        userDefaults.synchronize()
    }
    
    static func update(with item: WeatherInfo) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(item.id, forKey: Constants.UserDefaults.LAST_CITY_ID)
        userDefaults.setValue(item.weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(item.daytime, forKey: Constants.UserDefaults.IS_DAY_TIME)
        userDefaults.setValue(item.longitude, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(item.latitude, forKey: Constants.UserDefaults.LAST_LATITUDE)
        userDefaults.synchronize()
    }
    
    static func update(with item: Geoname) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(item.id, forKey: Constants.UserDefaults.LAST_CITY_ID)
        userDefaults.setValue(item.longitude, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(item.latitude, forKey: Constants.UserDefaults.LAST_LATITUDE)
        userDefaults.setValue(false, forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER)
        userDefaults.synchronize()
    }
    
    static func setShouldShowUserLocationWeather (_ value: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER)
        userDefaults.synchronize()
    }
}
