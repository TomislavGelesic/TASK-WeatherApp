//
//  CityWeatherResponse.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation


struct CityWeatherResponse: Codable {
    
    
    var id: String
    var name: String
    var coord: Coordinations_CityWeatherResponse
    var weather: Weather_CityWeatherResponse
    var main: Main_CityWeatherResponse
    var wind: Wind_CityWeatherResponse
}
