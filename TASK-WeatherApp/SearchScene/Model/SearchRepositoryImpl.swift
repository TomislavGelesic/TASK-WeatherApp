//
//  SearchRepositoryImpl.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import Combine
import Alamofire

class SearchRepositoryImpl: GeoNamesRepository {
    
    func fetchSearchResult(for searchText: String) -> AnyPublisher<Result<GeoNameResponse, AFError>, Never> {
        var path = String()
        path.append(Constants.GeoNamesORG.BASE_SearchScene)
        path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
        path.append(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        path.append(Constants.GeoNamesORG.MAX_ROWS)
        path.append("10")
        path.append(Constants.GeoNamesORG.KEY)
        return RestManager.requestObservable(url: path)
    }
}
