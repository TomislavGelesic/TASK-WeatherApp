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
    
    var searchRepository: NetworkRepository
    
    var viewModelData = [GeoNameItem]()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var inputSubject = CurrentValueSubject<String, Never>("")
    
    init(searchRepository: NetworkRepository) {
        
        self.searchRepository = searchRepository
    }
}

extension SearchSceneViewModel {
    
    func initializeInputSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .throttle(for: 0.5, scheduler: DispatchQueue.global(qos: .background), latest: true)
            .removeDuplicates()
            .map { [unowned self] (searchText) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                var path = String()
                path.append(Constants.GeoNamesORG.BASE)
                path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
                path.append(searchText)
                path.append(Constants.GeoNamesORG.MAX_ROWS)
                path.append("10")
                path.append(Constants.GeoNamesORG.KEY)
                #warning("delete print")
                print(path)
                guard let url = URL(string: path) else { fatalError("Creation of URL for searchText failed.") }
                
                
                
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink { (completion) in
                
                switch completion {
                case .finished:
                    
                    #warning("delete print")
                    print("doing good")
                    break
                    
                case .failure(let error):
                    
                    #warning("delete print")
                    print("doing bad")
                    print(error)
                    
                    switch error {
                    case .badResponseCode,.decodingError,.noDataError:
                        break
                    case .other(let error):
                        print("ERROR SearchSceneViewModel ERROR")
                        print(error)
                        break
                    }
                    break
                }
            } receiveValue: { [unowned self] (newData) in
                
                self.viewModelData = newData.geonames
                #warning("delete print")
                for item in self.viewModelData {
                    print(item.name)
                }
                self.refreshUISubject.send()
            }

    }
    
    func getScreenData(for position: Int) -> String {
        
        return "\(viewModelData[position].name), (\(viewModelData[position].countryName))"
    }
    
    func saveCity(at position: Int) {
        
        let item = viewModelData[position]
        
        UserDefaultsService.updateUserSettings(measurmentUnit: nil,
                                               lastCityId: item.geonameId,
                                               shouldShowWindSpeed: nil,
                                               shouldShowPressure: nil,
                                               shouldShowHumidity: nil)
        coreDataService.save(item)
    }
}
