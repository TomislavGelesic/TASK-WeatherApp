//
//  NetworkError.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import Foundation

enum NetworkError: Error {
    case badResponseCode
    case noDataError
    case decodingError
    case other(Error)
}
