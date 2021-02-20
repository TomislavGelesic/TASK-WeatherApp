//
//  RestManager.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 08.02.2021..
//

import Foundation
import Alamofire
import Combine

public class RestManager {
    private static let manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 50
//        configuration.timeoutIntervalForResource = 50
        let sessionManager = Session(configuration: configuration)
        
        return sessionManager
    }()
    
    static func requestObservable<T: Codable>(url: String) -> AnyPublisher<T, NetworkError> {
        
        return Future { promise in
            
            guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return promise(.failure(NetworkError.badResponseCode))
            }
            // HERE I STARTED
            let request = RestManager.manager
                .request(encodedUrl, encoding: URLEncoding.default)
                .validate()
                .responseData { (response) in
                    switch response.result {
                    case .success(let value):
                        if let decodedObject: T = SerializationManager.parseData(jsonData: value) {
                            promise(.success(decodedObject))
                        } else {
                            promise(.failure(NetworkError.decodingError))
                        }
                    case .failure:
                        promise(.failure(NetworkError.noDataError))
                    }
                }
            request.resume()
            
        }.eraseToAnyPublisher()
    }
    
}
