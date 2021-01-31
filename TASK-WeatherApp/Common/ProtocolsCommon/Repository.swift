//
//  Repository.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 29.01.2021..
//

import Foundation
import Combine

protocol Repository {
    
    associatedtype T
    
    var repositoryChanged: PassthroughSubject<T, RepositoryError> { get set }
    
    var getData: CurrentValueSubject<Bool, Never> { get set }
    
    var data: T { get set }
}
