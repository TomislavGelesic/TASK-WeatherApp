
import Foundation
import Combine
import CoreLocation
import Alamofire

protocol WeatherRepository: class {
    func fetchWeatherDataBy(location: CLLocationCoordinate2D) -> AnyPublisher<Result<WeatherResponse, AFError>, Never>
}
