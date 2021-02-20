//
//  Main_CityWeatherResponse.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation


struct Main_CityWeatherResponse:Codable {
    
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
    
}
