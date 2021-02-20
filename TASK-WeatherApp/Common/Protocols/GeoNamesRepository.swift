//
//  GeoNamesRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 02.02.2021..
//

import Foundation
import Combine
import Alamofire

protocol GeoNamesRepository: class {
    
    func fetchSearchResult(for searchText: String) -> AnyPublisher<Result<GeoNameResponse, AFError>, Never>
}
