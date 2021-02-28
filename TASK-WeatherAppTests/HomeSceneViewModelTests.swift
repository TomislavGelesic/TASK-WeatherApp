
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
        var mock = MockHomeSceneRepositoryImpl()
        var sut: HomeSceneViewModel!
        var coordinator = MockHomeSceneCoordinator(navigationController: UINavigationController())
        func cleanDisposeBag() { for cancellable in disposeBag { cancellable.cancel() } }
        
        func initialize() {
            sut = HomeSceneViewModel(repository: mock)
            sut.coordinatorDelegate = coordinator
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
                    stub(mock) { [unowned self] stub in
                        if let data: WeatherResponse = self.getResource("MockWeatherResponseJSON") {
                            let publisher = Just(Result<WeatherResponse, AFError>.success(data)).eraseToAnyPublisher()
                            when(stub).fetchWeatherDataBy(location: any()).thenReturn(publisher)
                        }
                    }
                    initialize()
                    subscribe()
                }
                it("Success screen initialized.") {
                    let expected: Int64 = 2761369
                    expect(sut.screenData.id).toEventually(equal(expected))
                }
            }
            
            context("Bad screen data initialize fail screen.") {
                beforeEach {
                    stub(mock) { stub in
                        let publisher = Just(Result<WeatherResponse, AFError>.failure(AFError.explicitlyCancelled)).eraseToAnyPublisher()
                        when(stub).fetchWeatherDataBy(location: any()).thenReturn(publisher)
                    }
                    initialize()
                    subscribe()
                }
                it("Fail screen initialized.") {
                    sut.alertSubject.send("")
                    expect(alertCalled).toEventually(equal(true))
                }
            }
        }
        
        describe("UNIT-TEST HomeSceneCoordinator") {
            context("Settings button tap call coordinator delegate.") {
                beforeEach {
                    stub(coordinator) { (stub) in
                        when(stub).viewControllerHasFinished(goTo: any()).thenDoNothing()
                    }
                    initialize()
                }
                it("Coordinator delegate called.") {
                    sut.coordinatorDelegate = coordinator
                    sut.settingsTapped(image: UIImage())
                    verify(coordinator).viewControllerHasFinished(goTo: any())
                }
            }
            
            context("Search textField tap call coordinator delegate.") {
                beforeEach {
                    stub(coordinator) { (stub) in
                        when(stub).viewControllerHasFinished(goTo: any()).thenDoNothing()
                    }
                    initialize()
                }
                it("Coordinator delegate called.") {
                    sut.coordinatorDelegate = coordinator
                    sut.presentSearchScene(on: nil, with: nil)
                    verify(coordinator).viewControllerHasFinished(goTo: any())
                }
            }
        }
    }
}
