//
//  GeoNamesNetworkService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import Combine
import Alamofire

class GeoNamesNetworkService {
    
    let subject = CurrentValueSubject<Bool, Never>(true)
    
    func fetch<T: Codable>(url: URL, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        
        return subject
            .flatMap { (_) in
                
                return Future<T, NetworkError> { promise in
                AF
                    .request(url)
                    .validate()
                    .responseData { (response) in
                        if let data = response.data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData: T = try decoder.decode(T.self, from: data)
                                promise(.success(decodedData))
                            }
                            catch {
                                promise(.failure(.decodingError))
                            }
                        } else {
                            promise(.failure(.noDataError))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
