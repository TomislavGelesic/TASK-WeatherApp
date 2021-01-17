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
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshUISubject = PassthroughSubject<Void, Never>()
    
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
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    
                    switch error {
                    case .badResponseCode,.decodingError,.noDataError:
                        break
                    case .other(let error):
                        self.alertSubject.send("Unkown error occured: \n\(error.localizedDescription)")
                    }
                    break
                }
                
            } receiveValue: { [unowned self] (newData) in
                
                self.viewModelData = newData.geonames
                self.refreshUISubject.send()
            }

    }
    
    func getScreenData(for position: Int) -> String {
        
        return "\(viewModelData[position].name), (\(viewModelData[position].countryName))"
    }
}
