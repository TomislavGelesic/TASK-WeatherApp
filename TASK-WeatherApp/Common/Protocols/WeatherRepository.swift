
import Foundation
import Combine
import CoreLocation

protocol WeatherRepository: class {
    
    func fetchWeatherDataBy(id: String) -> AnyPublisher<WeatherResponse, NetworkError>
    func fetchWeatherDataBy(location: CLLocationCoordinate2D) -> AnyPublisher<WeatherResponse, NetworkError>
    
}
