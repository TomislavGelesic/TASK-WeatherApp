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
    
    var screenData = [String]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
    #warning("String?! or some city parameter which i can get?!") //yes, iso3166_2 idNumber is needed - String/Double/Int
    var citySelectionSubject = PassthroughSubject<String, Never>()
    
    var searchNewCitiesSubject = PassthroughSubject<URL, Never>()
    
    init(searchRepository: NetworkRepository) {
        
        self.searchRepository = searchRepository
    }
}

extension SearchSceneViewModel {
    
    func initializeSearchSubject(subject: AnyPublisher<URL, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { [unowned self] (URLPath) -> AnyPublisher<GeoNameResponse, NetworkError> in
                
                return self.searchRepository.getNetworkSubject(ofType: GeoNameResponse.self, for: URLPath)
                
            }
            .throttle(for: 0.5, scheduler: DispatchQueue.global(qos: .background), latest: true)
            .map{ [unowned self] (data) in
                
                return self.createScreenData(from: data.geonames)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    
                        print("doing good")
                    break
                case .failure(let error):
                    
                    switch error {
                    case .badResponseCode,.decodingError,.noDataError:
                        print("doing error")
                        break
                    case .other(let error):
                        self.alertSubject.send("Unkown error occured: \n\(error.localizedDescription)")
                    }
                    break
                }
                
            } receiveValue: { [unowned self] (newScreenData) in
                self.screenData = newScreenData
                self.refreshUISubject.send()            }

    }
    
    func createScreenData(from items: [GeoNameItem]) -> [String] {
        
        return items.map { return "\($0.name), (\($0.countryName))" }
    }
}
