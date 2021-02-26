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
    
    var coordinatorDelegate: CoordinatorDelegate?
    var savedLocations = [WeatherInfo]()
    var coreDataService = CoreDataService.sharedInstance
    var userSettings = UserDefaultsService.fetchUpdated()
    var selectedConditions = [ConditionTypes]()
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
        coreDataService.delete(savedLocations[position].id)
        savedLocations.remove(at: position)
        if savedLocations.isEmpty { userSettings.shouldShowUserLocationWeather = true }
        else { userSettings.shouldShowUserLocationWeather = false }        
        refreshUISubject.send(true)
    }
    
    func applyTapped(_ type: MeasurementUnits) {
        saveUserSettings(measurmentUnit: type, wantedCity: nil, conditions: selectedConditions)
        coordinatorDelegate?.viewControllerHasFinished(goTo: .homeScene)
    }
    
    func backButtonTapped() { coordinatorDelegate?.viewControllerHasFinished(goTo: .homeScene) }
    
    func didSelectSavedCity(wantedCity position: Int?, _ unit: MeasurementUnits) {
        saveUserSettings(measurmentUnit: unit, wantedCity: position, conditions: selectedConditions)
        UserDefaultsService.setShouldShowUserLocationWeather(false)
        coordinatorDelegate?.viewControllerHasFinished(goTo: .homeScene)
    }
    
    func conditionTapped(_ type: ConditionTypes) {
        if selectedConditions.contains(type) { selectedConditions = selectedConditions.filter { $0 != type } }
        else { selectedConditions.append(type) }
    }
    
    func saveUserSettings(measurmentUnit: MeasurementUnits?, wantedCity position: Int?, conditions: [ConditionTypes]?) {
        if let unitToSave = measurmentUnit { userSettings.measurmentUnit = unitToSave }
        if let index = position {
            let city = savedLocations[index]
            userSettings.lastCityId = city.id
            userSettings.lastLatitude = city.latitude
            userSettings.lastLongitude = city.longitude
            UserDefaultsService.setShouldShowUserLocationWeather(false)
        }
        userSettings.shouldShowHumidity = false
        userSettings.shouldShowPressure = false
        userSettings.shouldShowWindSpeed = false
        if let conditionsToSave = conditions {
            for condition in conditionsToSave {
                switch condition {
                case .humidity: userSettings.shouldShowHumidity = true
                case .pressure: userSettings.shouldShowPressure = true
                case .windSpeed: userSettings.shouldShowWindSpeed = true
                }
            }
        }
        UserDefaultsService.update(with: userSettings)
        userSettings = UserDefaultsService.fetchUpdated()
        refreshUISubject.send(true)
    }
}
