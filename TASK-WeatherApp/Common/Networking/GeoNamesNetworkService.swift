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
    
    let publisher = PassthroughSubject<GeoNameResponse, NetworkError>()
    
    func fetch(url: URL) -> AnyPublisher<GeoNameResponse, NetworkError> {
        
        AF
            .request(url)
            .validate()
            .responseData { (response) in
                
                if let data = response.data {
                    
                    do {
                        let ok = try JSONSerialization.jsonObject(with: data, options: [])
                        let decoder = JSONDecoder()
                        let decodedData: T = try decoder.decode(T.self, from: data)
                        print(decodedData)
                        //                            promise(.success(decodedData))
                    }
                    catch {
                        promise(.failure(.decodingError))
                    }
                    
                } else {
                    
                    promise(.failure(.noDataError))
                }
            }
        return self.publisher.eraseToAnyPublisher()
    }
}

