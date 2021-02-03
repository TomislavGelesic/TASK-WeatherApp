//
//  RepositoryError.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 29.01.2021..
//

import Foundation

enum RepositoryError: Error {
    
    case notFound
    case other(error: Error)
}
