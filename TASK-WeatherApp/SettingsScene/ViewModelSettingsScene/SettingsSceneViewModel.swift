//
//  SettingsSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import SnapKit

class SettingsSceneViewModel {
    
    var savedLocations = [WeatherInfo]()
    
    var coreDataService = CoreDataService.sharedInstance
    
    var userSettings = UserDefaultsService.fetchUpdated()
    
    var refreshUISubject = CurrentValueSubject<Bool, Never>(true)
    
    init() {
        
        if let cities = coreDataService.get(.all) {
            savedLocations = cities
        }
    }
    
    deinit {
        print("SettingsSceneViewModel deinit")

    }
}

extension SettingsSceneViewModel {
    
    func remove(at position: Int) {
        
        if let id = Int64(savedLocations[position].id) {
            savedLocations.remove(at: position)
            coreDataService.delete(id)
            refreshUISubject.send(true)
        }
    }
    
    func saveUserSettings(measurmentUnit: MeasurementUnits?, wantedCity position: Int?, conditions: [ConditionTypes]?) {
        if let unitToSave = measurmentUnit {
            
            switch unitToSave {
            case .imperial:
                userSettings.measurmentUnit = .imperial
                break
            default:
                userSettings.measurmentUnit = .metric
                break
            }
        }
        
        if let index = position {
            userSettings.lastCityId = savedLocations[index].id
            UserDefaultsService.setShouldShowUserLocationWeather(false)
        }
        
        userSettings.shouldShowHumidity = false
        userSettings.shouldShowPressure = false
        userSettings.shouldShowWindSpeed = false
        
        if let conditionsToSave = conditions {
            for condition in conditionsToSave {
                switch condition {
                case .humidity:
                    userSettings.shouldShowHumidity = true
                    break
                case .pressure:
                    userSettings.shouldShowPressure = true
                    break
                case .windSpeed:
                    userSettings.shouldShowWindSpeed = true
                    break
                }
            }
            
        }
        
        UserDefaultsService.updateUserSettings(measurmentUnit: userSettings.measurmentUnit,
                                               lastCityId: userSettings.lastCityId,
                                               shouldShowWindSpeed: userSettings.shouldShowWindSpeed,
                                               shouldShowPressure: userSettings.shouldShowPressure,
                                               shouldShowHumidity: userSettings.shouldShowHumidity)
        
        userSettings = UserDefaultsService.fetchUpdated()
        
        refreshUISubject.send(true)
    }
}
