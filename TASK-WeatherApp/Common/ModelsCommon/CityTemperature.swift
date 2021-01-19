//
//  CityTemperature.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation

class CityTemperature {
    
    var minTemperature: Int
    var currentTemperature: Int
    var maxTemperature: Int
    
    init(minTemperature: Int, currentTemperature: Int, maxTemperature: Int) {
        
        self.minTemperature = minTemperature
        self.currentTemperature = currentTemperature
        self.maxTemperature = maxTemperature
    }
}
