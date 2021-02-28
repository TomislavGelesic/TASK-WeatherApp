
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
        var coordinatorCalled: SceneOption? = nil
        var alertCalled = false
        var disposeBag = Set<AnyCancellable>()
        var mock: MockHomeSceneRepositoryImpl!
        var sut: HomeSceneViewModel!
        var coordinator: MockHomeSceneCoordinator!
        func cleanDisposeBag() { for cancellable in disposeBag { cancellable.cancel() } }
        
        func initialize() {
            mock = MockHomeSceneRepositoryImpl()
            coordinator = MockHomeSceneCoordinator(navigationController: UINavigationController())
            sut = HomeSceneViewModel(repository: mock)
            sut.coordinatorDelegate = coordinator
            alertCalled = false
            coordinatorCalled = nil
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
        
        describe("UNIT-TEST HomeSceneCoordinator") {
            context("Settings button tap call coordinator delegate.") {
                beforeEach {
                    initialize()
                    stub(coordinator) { (stub) in
                        when(stub).viewControllerHasFinished(goTo: any()).then { (option) in
                            coordinatorCalled = option
                        }
                    }
                }
                it("Coordinator delegate called.") {
                    expect(coordinatorCalled).to(beNil())
                    sut.settingsTapped(image: UIImage())
                    expect(coordinatorCalled).toNot(beNil())
                }
            }
            
            context("Search textField tap call coordinator delegate.") {
                beforeEach {
                    initialize()
                    stub(coordinator) { (stub) in
                        when(stub).viewControllerHasFinished(goTo: any()).then { (option) in
                            coordinatorCalled = option
                        }
                    }
                }
                it("Coordinator delegate called.") {
                    expect(coordinatorCalled).to(beNil())
                    sut.presentSearchScene(on: HomeSceneViewController(viewModel: sut), with: UIImage())
                    sut.settingsTapped(image: UIImage())
                    expect(coordinatorCalled).toNot(beNil())
                }
            }
        }
    }
}
