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
    
    func fetch<T: Codable>(url: URL, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        
        let subject = PassthroughSubject<T, NetworkError>()
        
        return initializeSubject(subject: subject.eraseToAnyPublisher(),
                                 as: type,
                                 url: url)
        
    }
    
    func initializeSubject<T:Codable>(subject: AnyPublisher<T, NetworkError>, as: T.Type, url: URL) -> AnyPublisher<T, NetworkError> {
        
        return subject
            .map{
                AF
                    .request(url)
                    .validate()
                    .responseData { (response) in
                        if let data = response.data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData: T = try decoder.decode(T.self, from: data)
                                #warning("delete print")
                                subject.send(decodedData)
        //                        promise(.success(decodedData))
                            }
                            catch {
        //                        promise(.failure(.decodingError))
                            }
                        } else {
        //                    promise(.failure(.noDataError))
                        }
                    }
            }
            .eraseToAnyPublisher()
    }
}
