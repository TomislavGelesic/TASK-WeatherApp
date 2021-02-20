
import UIKit
import Combine
import CoreLocation
import Alamofire

class HomeSceneRepositoryImpl : WeatherRepository {
    
    func fetchWeatherDataBy(location: CLLocationCoordinate2D) -> AnyPublisher<Result<WeatherResponse, AFError>, Never> {
        
        var path = String()
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append("lat=\(location.latitude)&lon=\(location.longitude)")
        path.append(Constants.OpenWeatherMapORG.KEY)
        switch UserDefaultsService.fetchUpdated().measurmentUnit {
        case .metric: path.append(Constants.OpenWeatherMapORG.WITH_METRIC_UNITS)
        case .imperial: path.append(Constants.OpenWeatherMapORG.WITH_IMPERIAL_UNITS)
        }
        
        return RestManager.requestObservable(url: path)
    }
    
    
    func fetchWeatherDataBy(id: String) -> AnyPublisher<Result<WeatherResponse, AFError>, Never> {
        
        var path = String()
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append("id=\(id)")
        path.append(Constants.OpenWeatherMapORG.KEY)
        switch UserDefaultsService.fetchUpdated().measurmentUnit {
        case .metric:
            path.append(Constants.OpenWeatherMapORG.WITH_METRIC_UNITS)
            break
        case .imperial:
            path.append(Constants.OpenWeatherMapORG.WITH_IMPERIAL_UNITS)
            break
        }        
        return RestManager.requestObservable(url: path)
    }
    
    func getConditions() -> [ConditionTypes] {
        
        let userSettings = UserDefaultsService.fetchUpdated()
        
        var conditions = [ConditionTypes]()
        
        if userSettings.shouldShowHumidity {
            conditions.append(.humidity)
        }
        
        if userSettings.shouldShowPressure {
            conditions.append(.pressure)
        }
        
        if userSettings.shouldShowWindSpeed {
            conditions.append(.windSpeed)
        }
        
        return conditions
    }
}
