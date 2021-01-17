//
//  HomeSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine

class HomeSceneViewModel {
    
    var weatherInfo: WeatherInfo
    
    var userSettings: UserSettings
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    init(weatherInfo: WeatherInfo) {
        
        self.userSettings = UserDefaults.standard.object(forKey: "UserSettings") as? UserSettings ?? UserSettings()
        
        self.weatherInfo = weatherInfo
    }
    
}
