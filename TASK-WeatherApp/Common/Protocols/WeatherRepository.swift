
import Foundation
import Combine

protocol WeatherRepository: class {
    
    func fetchWeatherData(id: String) -> AnyPublisher<WeatherResponse, NetworkError>
    
}
