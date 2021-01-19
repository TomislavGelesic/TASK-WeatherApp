//
//  GeoNamesNetworkService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import Combine
import Alamofire

class GeoNamesNetworkService<T: Codable> {
    
    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, NetworkError> {
        
        return PassthroughSubject<T, NetworkError>
            .map { (_) -> AnyPublisher<T, NetworkError> in
                
                return  Future<T, NetworkError> { promise in
                    AF
                        .request(url)
                        .validate()
                        .responseData { (response) in
                            
                            if let data = response.data {
                                
                                do {
                                    let ok = try JSONSerialization.jsonObject(with: data, options: [])
                                    print(ok)
                                    let decoder = JSONDecoder()
                                    let decodedData: T = try decoder.decode(T.self, from: data)
                                    
                                    #warning("delete print")
                                    print(decodedData)
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
            
    }
        
}

