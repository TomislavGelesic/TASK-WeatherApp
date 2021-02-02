
import Foundation
import Combine

protocol WeatherRepository {
    
    func fetchNewData() -> AnyPublisher<WeatherResponse, NetworkError> 
    
}
