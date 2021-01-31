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
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var getData = CurrentValueSubject<Bool, Never>(true)
    
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
    
    func initializeGetData(for subject: CurrentValueSubject<Bool, Never>)-> AnyCancellable {
        
        return subject.map({ [unowned self] (_) -> [WeatherInfo] in
            if let valid = self.coreDataService.get(.all) {
                return valid
            }
            return [WeatherInfo]()
        })
        .subscribe(on: RunLoop.main)
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] savedCities in
            self.savedLocations = savedCities
            self.refreshUISubject.send()
        })
    }
    
    func remove(at position: Int) {
        
        if let id = Int64(savedLocations[position].id) {
            savedLocations.remove(at: position)
            coreDataService.delete(id)
            refreshUISubject.send()
        }
    }
    
    func saveUserSettings() {
        
        UserDefaultsService.updateUserSettings(measurmentUnit: userSettings.measurmentUnit,
                                               lastCityId: nil,
                                               shouldShowWindSpeed: userSettings.shouldShowWindSpeed,
                                               shouldShowPressure: userSettings.shouldShowPressure,
                                               shouldShowHumidity: userSettings.shouldShowHumidity)
        
        userSettings = UserDefaultsService.fetchUpdated()
        
    }
}
