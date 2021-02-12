
import UIKit
import Combine

class HomeSceneRepositoryImpl : WeatherRepository, GeoNamesRepository {
    
    func fetchWeatherData(id: String) -> AnyPublisher<WeatherResponse, NetworkError> {
        
        var path = String()
        path.append(Constants.OpenWeatherMapORG.BASE)
        path.append(Constants.OpenWeatherMapORG.GET_CITY_BY_ID)
        path.append("\(id)")
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
    
    func fetchSearchResult(for searchText: String) -> AnyPublisher<GeoNameResponse, NetworkError> {
        
        var path = String()
        path.append(Constants.GeoNamesORG.BASE_HomeScene)
        path.append(searchText)
        path.append(Constants.GeoNamesORG.KEY)
        
        return RestManager.requestObservable(url: path)
    }
}
