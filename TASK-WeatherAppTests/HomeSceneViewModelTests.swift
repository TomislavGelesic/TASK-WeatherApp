//
//  TASK_WeatherAppTests.swift
//  TASK-WeatherAppTests
//
//  Created by Tomislav Gelesic on 05.02.2021..
//

@testable import TASK_WeatherApp

import Cuckoo
import Quick
import Nimble
import Combine
import UIKit
import Alamofire
import CoreLocation

class HomeSceneViewModelTests: QuickSpec {
    
    func getResource<T: Codable>(_ fileName: String) -> T? {
        let bundle = Bundle.init(for: HomeSceneViewModelTests.self)
        guard let resourcePath = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: resourcePath),
              let parsedData: T = SerializationManager.parseData(jsonData: data) else { return nil }
        return parsedData
    }
    
    override func spec() {
        
        var alertCalled = false
        var disposeBag = Set<AnyCancellable>()
        var mock: MockHomeSceneRepositoryImpl!
        var sut: HomeSceneViewModel!
        
        func cleanDisposeBag() { for cancellable in disposeBag { cancellable.cancel() } }
        
        func initialize() {
            mock = MockHomeSceneRepositoryImpl()
            sut = HomeSceneViewModel(coordinator: HomeSceneCoordinator(parentCoordinator: AppCoordinator(),
                                                                       navigationController: UINavigationController()),
                                     repository: mock)
            alertCalled = false
        }
        
        func subscribe() {
            sut.initializeWeatherSubject(subject: sut.weatherSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
            sut.alertSubject
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: RunLoop.main)
                .sink { (_) in alertCalled = true}
                .store(in: &disposeBag)
        }
        
        describe("UNIT-TEST HomeSceneRepository") {
            context("Good screen data initialize success screen") {
                beforeEach {
                    initialize()
                    stub(mock) { [unowned self] stub in
                        if let data: WeatherResponse = self.getResource("MockWeatherResponseJSON") {
                            let publisher = Just(Result<WeatherResponse, AFError>.success(data)).eraseToAnyPublisher()
                            when(stub).fetchWeatherDataBy(location: any()).thenReturn(publisher)
                        }
                    }
                    subscribe()
                }
                afterEach { cleanDisposeBag() }
                it("Success screen initialized.") {
                    let expected: Int64 = 2761369
                    expect(sut.screenData.id).toEventually(equal(expected))
                }
            }
            
            context("Bad screen data initialize fail screen.") {
                beforeEach {
                    initialize()
                    subscribe()
                    stub(mock) { stub in
                        let publisher = Just(Result<WeatherResponse, AFError>.failure(AFError.explicitlyCancelled)).eraseToAnyPublisher()
                        when(stub).fetchWeatherDataBy(location: any()).thenReturn(publisher)
                    }
                    subscribe()
                }
                afterEach { cleanDisposeBag() }
                it("Fail screen initialized.") {
                    sut.alertSubject.send("")
                    expect(alertCalled).toEventually(equal(true))
                }
            }
        }
    }
}
