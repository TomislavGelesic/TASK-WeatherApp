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
    var latitude: Double
    var longitude: Double
    var shouldShowWindSpeed: Bool
    var shouldShowPressure: Bool
    var shouldShowHumidity: Bool
    var weatherType: Int
    var dayTime: Bool
    var shouldShowUserLocationWeather: Bool
    
    init(measurmentUnit: MeasurementUnits = .metric, lastCityId: String = Constants.DEFAULT_CITY_ID, shouldShowWindSpeed: Bool = false, shouldShowPressure: Bool = false, shouldShowHumidity: Bool = false, weatherType: Int = 800, dayTime: Bool = true, shouldShowUserLocationWeather: Bool = true, latitude: Double = 0.0, longitude: Double = 0.0) {
        self.measurmentUnit = measurmentUnit
        self.lastCityId = lastCityId
        self.shouldShowWindSpeed = shouldShowWindSpeed
        self.shouldShowPressure = shouldShowPressure
        self.shouldShowHumidity = shouldShowHumidity
        self.weatherType = weatherType
        self.dayTime = dayTime
        self.shouldShowUserLocationWeather = shouldShowUserLocationWeather
        self.latitude = latitude
        self.longitude = longitude
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
        
        if let latitude = userDefaults.value(forKey: Constants.UserDefaults.LAST_LATITUDE) as? Double {
            userSettings.latitude = latitude
        }
        
        if let longitude = userDefaults.value(forKey: Constants.UserDefaults.LAST_LONGITUDE) as? Double {
            userSettings.longitude = longitude
        }
        
        return userSettings
    }
    
    static func update(with userSettings: UserDefaultsService) {
        
        let userDefaults = UserDefaults.standard
        
        switch userSettings.measurmentUnit {
        case .imperial: userDefaults.setValue("imperial", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
        default: userDefaults.setValue("metric", forKey: Constants.UserDefaults.MEASURMENT_UNIT)
        }
        userDefaults.setValue(userSettings.lastCityId, forKey: Constants.UserDefaults.CITY_ID)
        userDefaults.setValue(userSettings.shouldShowPressure, forKey: Constants.UserDefaults.SHOULD_SHOW_PRESSURE)
        userDefaults.setValue(userSettings.shouldShowHumidity, forKey: Constants.UserDefaults.SHOULD_SHOW_HUMIDITY)
        userDefaults.setValue(userSettings.shouldShowWindSpeed, forKey: Constants.UserDefaults.SHOULD_SHOW_WIND_SPEED)
        userDefaults.setValue(userSettings.weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(userSettings.dayTime, forKey: Constants.UserDefaults.IS_DAY_TIME)
        userDefaults.setValue(userSettings.longitude, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(userSettings.latitude, forKey: Constants.UserDefaults.LAST_LATITUDE)
    }
    
    static func update(with weatherData: WeatherInfo) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(weatherData.id, forKey: Constants.UserDefaults.CITY_ID)
        userDefaults.setValue(weatherData.weatherType, forKey: Constants.UserDefaults.WEATHER_TYPE)
        userDefaults.setValue(weatherData.daytime, forKey: Constants.UserDefaults.IS_DAY_TIME)
        userDefaults.setValue(weatherData.longitude, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(weatherData.latitude, forKey: Constants.UserDefaults.LAST_LATITUDE)
    }
    
    static func update(with geoNameData: GeoNameItem) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(geoNameData.geonameId, forKey: Constants.UserDefaults.CITY_ID)
        userDefaults.setValue(geoNameData.lng, forKey: Constants.UserDefaults.LAST_LONGITUDE)
        userDefaults.setValue(geoNameData.lat, forKey: Constants.UserDefaults.LAST_LATITUDE)
    }
    
    static func setShouldShowUserLocationWeather (_ value: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: Constants.UserDefaults.SHOULD_SHOW_USER_LOCATION_WEATHER)
    }
}
