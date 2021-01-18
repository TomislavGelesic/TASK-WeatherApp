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
    
    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, NetworkError> {
        
        let subject = PassthroughSubject<T, NetworkError>()
            
        AF
            .request(url)
            .validate()
            .responseData { (response) in
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData: T = try decoder.decode(T.self, from: data)
                        subject.send(decodedData)
                    }
                    catch {
                    }
                }
                
            }
        return subject.eraseToAnyPublisher()
    }
}
