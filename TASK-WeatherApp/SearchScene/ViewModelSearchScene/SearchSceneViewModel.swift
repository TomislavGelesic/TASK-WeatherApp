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
    
    var coreDataService = CoreDataService.sharedInstance
    
    var searchRepository: NetworkService
    
    var viewModelData = [GeoNameItem]()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var inputSubject = CurrentValueSubject<String, Never>("")
    
    let fetchCitySubject = PassthroughSubject<String, Never>()
    
    init(searchRepository: NetworkService) {
        
        self.searchRepository = searchRepository
    }
    
    deinit {
        print("SearchSceneViewModel deinit")
    }
}

extension SearchSceneViewModel {
    
    func initializeInputSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .throttle(for: 0.5, scheduler: DispatchQueue.global(), latest: true)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { (completion) in
                
            } receiveValue: { [unowned self] (searchText) in
//                #warning("delete print")
//                print(searchText)
                self.fetchCitySubject.send(searchText)
            }
    }
    
    func initializeFetchSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { (searchText) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                var path = String()
                path.append(Constants.GeoNamesORG.BASE)
                path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
                path.append(searchText)
                path.append(Constants.GeoNamesORG.MAX_ROWS)
                path.append("10")
                path.append(Constants.GeoNamesORG.KEY)
//                #warning("delete print")
//                print(path)
                
                guard let url = URL(string: path) else { fatalError("Creation of URL for searchText failed.") }
                
                return self.searchRepository.getNetworkSubject(for: url).eraseToAnyPublisher()
                
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                
            }, receiveValue: { [unowned self] (response) in
                
                self.viewModelData = response.geonames
                self.refreshUISubject.send()
            })
    }
    
    func getScreenData(for position: Int) -> String {
        
        return "\(viewModelData[position].name), (\(viewModelData[position].countryName))"
    }
    
    func saveCity(at position: Int) {
        
        let item = viewModelData[position]
        
        UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                               lastCityId: String(item.geonameId),
                                               shouldShowWindSpeed: nil,
                                               shouldShowPressure: nil,
                                               shouldShowHumidity: nil)
        coreDataService.save(item)
    }
}
