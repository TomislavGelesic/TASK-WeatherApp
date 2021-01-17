//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import SnapKit

class HomeSceneViewModel {
    
    var weather: CityWeatherItem
    
    
    
    init(weatherInfo: CityWeatherItem) {
        
        self.weather = weatherInfo
    }
    
    
    
}
