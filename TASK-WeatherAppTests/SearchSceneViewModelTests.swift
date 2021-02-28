
@testable import TASK_WeatherApp

import Cuckoo
import Quick
import Nimble
import Combine
import UIKit
import Alamofire
import CoreLocation

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
                    stub(mock) { [unowned self] stub in
                        if let data: GeoNameResponse = self.getResource("MockGeonameResponseJSON")
                        {
                            #warning("delete print")
                            print(data)
                            when(stub).fetchSearchResult(for: any())
                                .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data)).eraseToAnyPublisher())
                        }
                        else {
                            #warning("delete print")
                            print("ERRRRROOOOORRRRR")
                        }
                    }
                    subscribe()
                }
                afterEach { cleanDisposeBag() }
                it("Success screen initialized.") {
                    let expected: Int = 10
                    
                    //it's passthrough subject
                    sut.searchSubject.send("Vienna")
                    
                    #warning("unknown fail")
                    //why does it fail??
                    
                    expect(sut.screenData.count).toEventually(equal(expected))
                }
            }
            
            context("Bad screen data initialize fail screen") {
                beforeEach {
                    initialize()
                    stub(mock) { stub in
                        let data = GeoNameResponse(geonames: [GeoNameItem]())
                        when(stub).fetchSearchResult(for: any())
                            .thenReturn(Just(Result<GeoNameResponse, AFError>.success(data)).eraseToAnyPublisher())
                    }
                    subscribe()
                }
                afterEach { cleanDisposeBag() }
                it("Fail screen initialized.") {
                    let expected: Int = 0
                    sut.searchSubject.send("Vienna")
                    expect(sut.screenData.count).toEventually(equal(expected))
                }
            }
        }
    }
}
