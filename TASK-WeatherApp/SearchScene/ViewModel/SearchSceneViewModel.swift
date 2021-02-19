//
//  SearchSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import SnapKit


class SearchSceneViewModel {
    
    var coordinator: SearchSceneCoordinator
    
    var coreDataService = CoreDataService.sharedInstance
    
    var searchRepository: GeoNamesRepository
    
    var screenData = [GeoNameItem]()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    let fetchCitySubject = PassthroughSubject<String, Never>()
    
    init(coordinator: SearchSceneCoordinator, searchRepository: GeoNamesRepository) {
        self.coordinator = coordinator
        self.searchRepository = searchRepository
    }
    
    deinit {
//        print("SearchSceneViewModel deinit")
    }
}

extension SearchSceneViewModel {
    
    func initializeFetchSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .flatMap { [unowned self] (searchText) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                return self.searchRepository.fetchSearchResult(for: searchText)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                
            }, receiveValue: { [unowned self] (response) in
                
                self.screenData = response.geonames
                self.refreshUISubject.send()
            })
    }
    
    func getScreenData(for position: Int) -> String {
        
        return "\(screenData[position].name), (\(screenData[position].countryName))"
    }
    
    func saveCity(at position: Int) {
        
        let item = screenData[position]
        UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                               lastCityId: String(item.geonameId),
                                               shouldShowWindSpeed: nil,
                                               shouldShowPressure: nil,
                                               shouldShowHumidity: nil)
        coreDataService.save(item)
    }
    
    func cancelTapped() {
        coordinator.goToHomeScene()
    }
    
    func didSelectCity(at position: Int) {
        saveCity(at: position)
        UserDefaultsService.setShouldShowUserLocationWeather(false)
        coordinator.goToHomeScene()
    }
}