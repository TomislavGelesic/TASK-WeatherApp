
@testable import TASK_WeatherApp

import Cuckoo
import Quick
import Nimble
import Combine
import UIKit
import Alamofire

class SearchSceneViewModelTests: QuickSpec {
    
    func getResource<T: Codable>(_ fileName: String) -> T? {
        let bundle = Bundle.init(for: SearchSceneViewModelTests.self)
        guard let resourcePath = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: resourcePath),
              let parsedData: T = SerializationManager.parseData(jsonData: data) else { return nil }
        return parsedData
    }
    
    override func spec() {
        
        var alertCalled = false
        var disposeBag = Set<AnyCancellable>()
        var mock: MockSearchRepositoryImpl!
        var sut: SearchSceneViewModel!
        
        func cleanDisposeBag() { for cancellable in disposeBag { cancellable.cancel() } }
        
        func initialize() {
            mock = MockSearchRepositoryImpl()
            sut = SearchSceneViewModel(searchRepository: mock)
            alertCalled = false
        }
        
        func subscribe() {
            sut.initializeSearchSubject(subject: sut.searchSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
            sut.alertSubject
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: RunLoop.main)
                .sink { (_) in alertCalled = true}
                .store(in: &disposeBag)
        }
        
        describe("UNIT-TEST SearchRepository") {
            context("Good screen data initialize success screen") {
                beforeEach {
                    initialize()
                    stub(mock) { [unowned self] stub in // just for desired search
                        if let data1: GeoNameResponse = self.getResource("MockGeonameResponseJSON_1"), // V
                           let data2: GeoNameResponse = self.getResource("MockGeonameResponseJSON_2"), // i
                           let data3: GeoNameResponse = self.getResource("MockGeonameResponseJSON_3"), // e
                           let data4: GeoNameResponse = self.getResource("MockGeonameResponseJSON_4"), // n
                           let data5: GeoNameResponse = self.getResource("MockGeonameResponseJSON_5"), // n
                           let data6: GeoNameResponse = self.getResource("MockGeonameResponseJSON_6")  // a
                        {
                            let publisher =
                            when(stub).fetchSearchResult(for: any())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data1)).eraseToAnyPublisher())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data2)).eraseToAnyPublisher())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data3)).eraseToAnyPublisher())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data4)).eraseToAnyPublisher())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data5)).eraseToAnyPublisher())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data6)).eraseToAnyPublisher())
                            
                        }
                    }
                    subscribe()
                }
                afterEach { cleanDisposeBag() }
                it("Success screen initialized.") {
                    let expected: Int = 0
                    
                    expect(sut.screenData.count).toEventually(equal(expected))
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
