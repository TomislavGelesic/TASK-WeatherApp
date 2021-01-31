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
    
    var settingsRepository: SettingsRepositoryImpl
    
    var refreshUISubject = PassthroughSubject<UserDefaultsService, Never>()
    
    init(repository: SettingsRepositoryImpl) {
        
        self.settingsRepository = repository
        
        setSubscribers()
    }
    
    deinit {
        
        print("SettingsSceneViewModel deinit")
    }
}

extension SettingsSceneViewModel {
    
    func setSubscribers() {    }
    
    func remove(at position: Int) {
        
        let id = savedLocations[position].id
        savedLocations.remove(at: position)
        coreDataService.delete(id)
        refreshUISubject.send(userSettings)
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
