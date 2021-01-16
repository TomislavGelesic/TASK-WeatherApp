//
//  CityWeather.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation

class CityWeather {
    
    var meassurmentUnit: MeassurmentUnits
    var name: String
    var temperature: CityTemperature
    var weatherDescription:String
    var windSpeed: Int
    
    
    init(meassurmentUnit: MeassurmentUnits = .metric, name: String = "", temperature: CityTemperature, weatherDescription: String = "", windSpeed: Int) {
        self.meassurmentUnit = meassurmentUnit
        self.name = name
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.windSpeed = windSpeed
    }
}
