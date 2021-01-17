//
//  CityWeatherRepository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import UIKit
import Combine

class CityWeatherRepository: NetworkRepository {
    
    func getNetworkSubject<DATA_TYPE>(ofType type: DATA_TYPE.Type, for url: URL) -> AnyPublisher<DATA_TYPE, NetworkError> where DATA_TYPE : Decodable, DATA_TYPE : Encodable {
        
        return OpenWeatherMapNetworkService().fetch(url: url, as: type)
    }
}
