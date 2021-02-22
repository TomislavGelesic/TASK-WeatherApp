//
//  SearchSceneViewModel.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit
import Combine
import SnapKit


class SearchSceneViewModel {
    
    var delegate: HomeSceneViewController?
    var searchRepository: GeoNamesRepository
    var screenData = [Geoname]()
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    var alertSubject = PassthroughSubject<String, Never>()
    var refreshUISubject = PassthroughSubject<Void, Never>()
    let searchSubject = PassthroughSubject<String, Never>()
    
    init(searchRepository: GeoNamesRepository) { self.searchRepository = searchRepository }
    
    deinit { print("SearchSceneViewModel deinit") }
}

extension SearchSceneViewModel {
    
    func initializeSearchSubject(subject: AnyPublisher<String, Never>) -> AnyCancellable {
        
        return subject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .removeDuplicates()
            .flatMap { [unowned self] (searchText) -> AnyPublisher<[Geoname], Never> in
                return self.searchRepository.fetchSearchResult(for: searchText)
                    .flatMap { (result) -> AnyPublisher<[Geoname], Never> in
                        switch result {
                        case .success(let geonamesResponse):
                            let data: [Geoname] = geonamesResponse.geonames.map{ Geoname($0) }
                            return Just(data).eraseToAnyPublisher()
                        case .failure(let error):
                            print(error)
                            return Just([Geoname]()).eraseToAnyPublisher()
                        }
                    }.eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(_): print("THIS ERROR SHOULD NEVER HAPPEN")
                }
            }, receiveValue: { [unowned self] (data) in
                self.screenData = data
                self.refreshUISubject.send()
            })
    }
    
    func search(text: String?) {
        if let text = text { searchSubject.send(text) }
        else {
            screenData.removeAll()
            refreshUISubject.send()
        }
    }
    
    func getScreenData(for position: Int) -> String { return "\(screenData[position].name), (\(screenData[position].countryName))" }
    
    func didSelectCancel() { delegate?.returnToHomeScene(nil) }
    
    func didSelectCity(at position: Int) { delegate?.returnToHomeScene(screenData[position]) }
}
