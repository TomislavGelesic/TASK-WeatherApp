//
//  CityWeatherItem.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation

class WeatherInfo {
    
    var id: String = "-1"
    var cityName: String = ""
    var weatherDescription: String = ""
    var pressure: String = "-1"
    var windSpeed: String = "-1"
    var humidity: String = "-1"
    var min_Temperature: String = "X"
    var current_Temperature: String = "X"
    var max_Temperature: String = "X"
    var weatherType: String = "800"
    
    internal init(id: String = "-1",
                  cityName: String = "",
                  weatherDescription: String = "",
                  pressure: String = "-1",
                  windSpeed: String = "-1",
                  humidity: String = "-1",
                  min_Temperature: String = "X",
                  current_Temperature: String = "X",
                  max_Temperature: String = "X",
                  weatherType: String = "800") {
        self.id = id
        self.cityName = cityName
        self.weatherDescription = weatherDescription
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.min_Temperature = min_Temperature
        self.current_Temperature = current_Temperature
        self.max_Temperature = max_Temperature
        self.weatherType = weatherType
    }
    
    init(_ coreDataItem: CityWeather) {
        
        self.id = String(coreDataItem.id)
        self.cityName = coreDataItem.name ?? ""
    }
    
}