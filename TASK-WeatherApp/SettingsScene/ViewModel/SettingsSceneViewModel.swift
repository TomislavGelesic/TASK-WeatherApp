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
    
    
    var coordinator: SettingsSceneCoordinator
    
    var savedLocations = [WeatherInfo]()
    
    var coreDataService = CoreDataService.sharedInstance
    
    var userSettings = UserDefaultsService.fetchUpdated()
    
    var selectedConditions = [ConditionTypes]()
    
    var refreshUISubject = CurrentValueSubject<Bool, Never>(true)
    
    init(coordinator: SettingsSceneCoordinator) {
        
        self.coordinator = coordinator
        
        if let cities = coreDataService.get(.all) {
            savedLocations = cities
        }
        
    }
    
    deinit {
//        print("SettingsSceneViewModel deinit")
    }
}

extension SettingsSceneViewModel {
    
    func remove(at position: Int) {
        
        if let id = Int64(savedLocations[position].id) {
            savedLocations.remove(at: position)
            coreDataService.delete(id)
            userSettings.shouldShowUserLocationWeather = true
            refreshUISubject.send(true)
        }
    }
    
    func applyTapped(_ type: MeasurementUnits) {
        print("selected unit is: \(type)")
        saveUserSettings(measurmentUnit: type,
                         wantedCity: nil,
                         conditions: selectedConditions)
        
        coordinator.returnToHomeScene()
    }
    
    func backButtonTapped() {
        coordinator.returnToHomeScene()
    }
    
    func didSelectSavedCity(wantedCity position: Int?, _ unit: MeasurementUnits) {
        saveUserSettings(measurmentUnit: unit,
                         wantedCity: position,
                         conditions: selectedConditions)
        coordinator.returnToHomeScene()
    }
    
    func conditionTapped(_ type: ConditionTypes) {
        if selectedConditions.contains(type) {
            selectedConditions = selectedConditions.filter { $0 != type }
        }
        else {
            selectedConditions.append(type)
        }
    }
    
    func saveUserSettings(measurmentUnit: MeasurementUnits?, wantedCity position: Int?, conditions: [ConditionTypes]?) {
        if let unitToSave = measurmentUnit {
            userSettings.measurmentUnit = unitToSave
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
