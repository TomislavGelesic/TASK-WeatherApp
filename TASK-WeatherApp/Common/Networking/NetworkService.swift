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
    
    func fetchData<T>(for url: URL) -> AnyPublisher<T, NetworkError> where T : Decodable, T : Encodable {
        
        return Future<T, NetworkError> { promise in
            AF
                .request(url)
                .validate()
                .responseData { (response) in
                    
                    if let data = response.data {
                        do {
//                            let decodedData = try JSONSerialization.jsonObject(with: data, options: [])
//                            print(decodedData)
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
    
}
