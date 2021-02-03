
import Foundation
import Combine

protocol WeatherRepository {
    
    func fetchWeatherData(id: String) -> AnyPublisher<WeatherResponse, NetworkError>
    
}
