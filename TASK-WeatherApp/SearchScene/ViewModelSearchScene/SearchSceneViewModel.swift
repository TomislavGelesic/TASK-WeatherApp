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
    
    var searchRepository: NetworkRepository
    
    var viewModelData = [GeoNameItem]()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    var searchNewCitiesSubject = CurrentValueSubject<String, Never>("")
    
    init(searchRepository: NetworkRepository) {
        
        self.searchRepository = searchRepository
    }
}

extension SearchSceneViewModel {
    
    func initializeSearchSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .removeDuplicates()
            .map { [unowned self] (searchText) -> URL in
                #warning("delete print")
                print(searchText)
                return self.makeGeoNamesURL(for: searchText)
            }
            .map { [unowned self] (URLPath) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                #warning("delete print")
                print("im here")
                return self.searchRepository.getNetworkSubject(ofType: GeoNameResponse.self, for: URLPath)
                
            }
            .switchToLatest()
            .subscribe(on: RunLoop.main)
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
    
    func makeGeoNamesURL(for searchText: String) -> URL {
        
        var path = String()
        path.append(Constants.GeoNamesORG.BASE)
        path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
        path.append(searchText)
        path.append(Constants.GeoNamesORG.MAX_ROWS)
        path.append("10")
        path.append(Constants.GeoNamesORG.KEY)
        
        guard let url = URL(string: path) else { fatalError("Creation of URL for searchText failed.") }
        
        return url
    }
}
