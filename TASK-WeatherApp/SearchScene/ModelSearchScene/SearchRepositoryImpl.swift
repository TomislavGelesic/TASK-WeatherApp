//
//  SearchRepositoryImpl.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import Combine

class SearchRepositoryImpl: NetworkRepository {
    
    func getNetworkSubject<DATA_TYPE: Codable>(ofType type: DATA_TYPE.Type, for url: URL) -> AnyPublisher<DATA_TYPE, NetworkError> {
        
        return GeoNamesNetworkService<DATA_TYPE>().fetch(url: url, as: type)
    }
}
