
import Foundation
import Combine
import CoreLocation
import Alamofire

protocol WeatherRepository: class {
    
    func fetchWeatherDataBy(id: String) -> AnyPublisher<Result<WeatherResponse, AFError>, Never>
    func fetchWeatherDataBy(location: CLLocationCoordinate2D) -> AnyPublisher<Result<WeatherResponse, AFError>, Never>
    
}
