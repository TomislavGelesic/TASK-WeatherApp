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
    var daytime: Bool = false
    
    init(id: String = "-1",
         cityName: String = "",
         weatherDescription: String = "",
         pressure: String = "-1",
         windSpeed: String = "-1",
         humidity: String = "-1",
         min_Temperature: String = "X",
         current_Temperature: String = "X",
         max_Temperature: String = "X",
         weatherType: String = "800",
         daytime: Bool = false) {
        
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
        self.daytime = daytime
    }
    
    init(_ coreDataItem: CityWeather) {
        
        self.id = String(coreDataItem.id)
        self.cityName = coreDataItem.name ?? ""
    }
    
    init (_ response: WeatherResponse) {
        
        id                      = String(response.id)
        cityName                = String(response.name)
        weatherDescription      = String(response.weather.description)
        pressure                = String(response.main.pressure)
        windSpeed               = String(response.wind.speed)
        humidity                = String(response.main.humidity)
        min_Temperature         = String(response.main.temp_min)
        current_Temperature     = String(response.main.temp)
        max_Temperature         = String(response.main.temp_max)
        weatherType             = String(response.weather.id)
        daytime                 = response.weather.icon.suffix(1) == "d" ? true : false
        
    }
    
}
