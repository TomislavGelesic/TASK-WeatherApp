//
//  OpenWeatherMapNetworkService.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 17.01.2021..
//

import Foundation
import Combine
import Alamofire

class OpenWeatherMapNetworkService {
    
    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, NetworkError> {
        #warning("delete print")
          print(url)
        return Future<T, NetworkError> { promise in
            AF
                .request(url)
                .validate()
                .responseData { (response) in
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            
                            if let r = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                                print(r)
                            }
                            
                            
                            print(" ______________________ ")
                            let decodedData: T = try decoder.decode(T.self, from: data)
                            promise(.success(decodedData))
                        }
                        catch {
                            promise(.failure(.decodingError))
                        }
                    }
                    promise(.failure(.noDataError))
                }
        }.eraseToAnyPublisher()
    }
}
