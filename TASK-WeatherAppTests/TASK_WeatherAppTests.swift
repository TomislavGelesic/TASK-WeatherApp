//
//  TASK_WeatherAppTests.swift
//  TASK-WeatherAppTests
//
//  Created by Tomislav Gelesic on 05.02.2021..
//

import Cuckoo
import Quick
import Nimble
import Combine
import UIKit

@testable import TASK_WeatherApp


class TASK_WeatherAppTests: QuickSpec {
    
    func getResource<T: Codable>() -> T? {
        
        let bundle = Bundle.init(for: TASK_WeatherAppTests.self)
        
        guard let resourcePath = bundle.url(forResource: "MockWeatherResponseJSON", withExtension: "json"),
              let data = try? Data(contentsOf: resourcePath),
              let parsedData: T = SerializationManager.parseData(jsonData: data) else {
            return nil
        }
        
        return parsedData
        
    }
    
    override func spec() {
        
        let mock = MockHomeSceneRepositoryImpl()
        let sut = HomeSceneViewModel(repository: mock)
        var disposeBag = Set<AnyCancellable>()
        
        describe("HomeScene repository test") {
            
            it("has correct weather data ") {
                // ARRANGE
                stub(mock) { [unowned self] stub in
                    
                    if let data: WeatherResponse = self.getResource() {
                        print(data.id)
                        let publisher = CurrentValueSubject<WeatherResponse, NetworkError>(data).eraseToAnyPublisher()
                        when(stub).fetchWeatherData(id: any()).thenReturn(publisher)
                    } else {
                        print("didnt enter")
                    }
                }
                
                let expected: Double = 2761369
                var actual: Double = 0
                
                // ACT
                
                waitUntil { (done) in
                    mock.fetchWeatherData(id: "")
                        .map({ WeatherInfo($0) })
                        .subscribe(on: RunLoop.main)
                        .receive(on: RunLoop.main)
                        .sink { (completion) in
                            switch completion {
                            case .failure(let error):
                                print(error)
                                fail("## This test should not fail. ##")
                                break
                            case .finished:
                                break
                            }
                        } receiveValue: { (weatherInfo) in
                            actual = Double(weatherInfo.id) ?? 0
                            done()
                        }
                        .store(in: &disposeBag)
                }
                
                // ASSERT
                
                expect(actual).to(equal(expected))
                
                //  waitUntil above or polling below, both work, waitUntil is optimised
                
                // expect(actualData).toEventually(equal(expectedData), timeout: .milliseconds(3000), pollInterval: .milliseconds(500))
                
            }
            
            
            it("calls alert correctly") {
                
                // ARRANGE
                
                stub(mock) { stub in
                    
                    when(stub).fetchWeatherData(id: any()).thenReturn(Fail(error: NetworkError.badResponseCode).eraseToAnyPublisher())
                }
                
                let expected: Bool = true
                var actual: Bool = false
                
                // ACT
                
                waitUntil { (done) in
                    mock.fetchWeatherData(id: "")
                        .map({ WeatherInfo($0) })
                        .subscribe(on: RunLoop.main)
                        .receive(on: RunLoop.main)
                        .sink { (completion) in
                            switch completion {
                            case .failure(_):
                                actual = true
                                done()
                                break
                            case .finished:
                                fail("## This test should not succeed. ##")
                                break
                            }
                        } receiveValue: { (_) in
                        }
                        .store(in: &disposeBag)
                }
                
                // ASSERT
                
                expect(actual).to(equal(expected))
            }
        }
    }
    
   
}
