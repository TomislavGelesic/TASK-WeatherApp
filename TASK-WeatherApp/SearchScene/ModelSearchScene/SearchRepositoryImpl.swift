//
//  SearchRepositoryImpl.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import Combine

class SearchRepositoryImpl: GeoNamesRepository {
    
    
    func fetchSearchResult(for searchText: String) -> AnyPublisher<GeoNameResponse, NetworkError> {
        var path = String()
        path.append(Constants.GeoNamesORG.BASE)
        path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
        path.append(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        path.append(Constants.GeoNamesORG.MAX_ROWS)
        path.append("10")
        path.append(Constants.GeoNamesORG.KEY)
        
        guard let url = URL(string: path) else { fatalError("Creation of URL for searchText failed.") }
        
        return NetworkService().fetchData(for: url).eraseToAnyPublisher()
    }
    
}
