//
//  NetworkService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 29.01.2021..
//

import UIKit
import Combine
import Alamofire

class NetworkService {
    
    var subject = PassthroughSubject<Void, NetworkError>().eraseToAnyPublisher()
    
    func getNetworkSubject<T>(for url: URL) -> AnyPublisher<T, NetworkError> where T : Decodable, T : Encodable {
        
        return initializeSubject(subject: subject, for: url)
    }
    
    func initializeSubject<T: Codable>(subject: AnyPublisher<Void, NetworkError>, for url: URL) -> AnyPublisher<T, NetworkError> {
        
        return subject
            .flatMap{ [unowned self] (_) in
            
            return Future<T, NetworkError> { promise in
                AF
                    .request(url)
                    .validate()
                    .responseData { (response) in
                        
                        if let data = response.data {
                            do {
                                //                            let ok = try JSONSerialization.jsonObject(with: data, options: [])
                                //                            print(ok)
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
        }.eraseToAnyPublisher()
        
            
    }
    
}
