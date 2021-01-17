//
//  CityWeatherItem.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation

class CityWeatherItem {
    
    
    var id: String = "-1"
    var name: String = ""
    var pressure: String = "-1"
    var windSpeed: String = "-1"
    var humidity: String = "-1"
    
    
    init(id: String = "-1", name: String = "", pressure: String = "-1", windSpeed: String = "-1", humidity: String = "-1") {
        self.id = id
        self.name = name
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.humidity = humidity
    }
    
    init(_ coreDataItem: CityWeather) {
        
        self.id = String(coreDataItem.id)
        self.name = coreDataItem.name ?? ""
    }
    
}
