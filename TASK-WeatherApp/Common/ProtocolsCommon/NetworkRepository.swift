//
//  NetworkRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import Combine

protocol NetworkRepository {
    
    func getNetworkSubject<DATA_TYPE: Codable> (ofType type: DATA_TYPE.Type, for url: URL) -> AnyPublisher<DATA_TYPE, NetworkError>

}
