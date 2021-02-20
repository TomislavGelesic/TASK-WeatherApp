//
//  CityWeatherItem.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation

class WeatherInfo {
    
    var id: String = ""
    var cityName: String = ""
    var weatherDescription: String = ""
    var pressure: String = ""
    var windSpeed: String = ""
    var humidity: String = ""
    var min_Temperature: String = ""
    var current_Temperature: String = ""
    var max_Temperature: String = ""
    var weatherType: String = "800"
    var daytime: Bool = false
    var latitude: String = "0.0"
    var longitude: String = "0.0"
    
    init(id: String = "",
         cityName: String = "",
         weatherDescription: String = "",
         pressure: String = "",
         windSpeed: String = "",
         humidity: String = "",
         min_Temperature: String = "",
         current_Temperature: String = "",
         max_Temperature: String = "",
         weatherType: String = "800",
         daytime: Bool = false,
         latitude: String = "0.0",
         longitude: String = "0.0") {
        
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
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ coreDataItem: CityWeather) {
        
        self.id = String(coreDataItem.id)
        self.cityName = coreDataItem.name ?? ""
        self.longitude = coreDataItem.longitude ?? ""
        self.latitude = coreDataItem.latitude ?? ""
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
        latitude                = String(response.coord.lat)
        longitude               = String(response.coord.lon)
    }
    
}
