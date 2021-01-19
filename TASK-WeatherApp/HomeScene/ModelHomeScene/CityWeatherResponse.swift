//
//  CityWeatherResponse.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation


struct CityWeatherResponse: Codable {
    
    
    var id: Double
    var name: String
    var coord: Coordinations_CityWeatherResponse
    var weather: Weather_CityWeatherResponse
    var main: Main_CityWeatherResponse
    var wind: Wind_CityWeatherResponse
    
    init(from decoder: Decoder) throws {
        
        let keyedDecoder = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.id = keyedDecoder.decode(Double.self, forKey: .id)
        try self.name = keyedDecoder.decode(String.self, forKey: .name)
        try self.coord = keyedDecoder.decode(Coordinations_CityWeatherResponse.self, forKey: .coord)
        try self.main = keyedDecoder.decode(Main_CityWeatherResponse.self, forKey: .main)
        try self.wind = keyedDecoder.decode(Wind_CityWeatherResponse.self, forKey: .wind)
        try self.weather = keyedDecoder.decode([Weather_CityWeatherResponse].self, forKey: .weather).first ?? Weather_CityWeatherResponse(id: 800, description: "fail")
    }
}

extension CityWeatherResponse {
    
    enum CodingKeys: CodingKey {
        
        case id
        case name
        case coord
        case weather
        case main
        case wind
    }
}
