//
//  GeoNamesRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 02.02.2021..
//

import Foundation
import Combine

protocol GeoNamesRepository: class {
    
    func fetchSearchResult(for searchText: String) -> AnyPublisher<GeoNameResponse, NetworkError>
}
