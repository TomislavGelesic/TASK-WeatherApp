//
//  Constants.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation
import CoreLocation

struct Constants {
    
    // Vienna
    static let DEFAULT_CITY_ID: Int64 = 2761369
    static let DEFAULT_LATITUDE: Double = 48.20849
    static let DEFAULT_LONGITUDE: Double = 16.37208
    static let DEFAULT_LOCATION = CLLocationCoordinate2D(latitude: Constants.DEFAULT_LATITUDE, longitude: Constants.DEFAULT_LONGITUDE)
    
    struct GeoNamesORG  {
        static let BASE_HomeScene = "https://secure.geonames.org/findNearbyPlaceNameJSON?"
        static let BASE_SearchScene = "https://secure.geonames.org/searchJSON?"
        static let GET_CITY_BY_NAME = "name_startsWith="
        static let MAX_ROWS = "&maxRows="
        static let KEY = "&username=tgelesic"
    }
    
//    examples:
//    https://secure.geonames.org/searchJSON?name_startsWith=Vienna&maxRows=10&username=tgelesic
    
    
    struct OpenWeatherMapORG {
        static let BASE = "https://api.openweathermap.org/data/2.5/weather?"
        static let KEY = "&appid=" + "c89f972e8095d59db84f5e88b5ad621e"
        static let WITH_METRIC_UNITS = "&units=metric"
        static let WITH_IMPERIAL_UNITS = "&units=imperial"
    }
    
//    examples Vienna = 2761369:
//    https://api.openweathermap.org/data/2.5/weather?q=Vienna,WV&appid=c89f972e8095d59db84f5e88b5ad621e&units=metric

//    https://api.openweathermap.org/data/2.5/weather?id=2761369&appid=c89f972e8095d59db84f5e88b5ad621e&units=metric

    struct UserDefaults {
        static let LAST_CITY_ID = "lastcityid"
        static let SHOULD_SHOW_HUMIDITY = "humidity"
        static let SHOULD_SHOW_PRESSURE = "pressure"
        static let SHOULD_SHOW_WIND_SPEED = "windspeed"
        static let MEASURMENT_UNIT = "measurmentunit"
        static let WEATHER_TYPE = "weathertype"
        static let IS_DAY_TIME = "daytime"
        static let SHOULD_SHOW_USER_LOCATION_WEATHER = "shouldShowUserLocationWeather"
        static let LAST_LATITUDE = "lastlatitude"
        static let LAST_LONGITUDE = "lastlongitude"
    }
    
    static func getPath(for searchText: String) -> String {
        var path = ""
        path.append(Constants.GeoNamesORG.BASE_SearchScene)
        path.append(Constants.GeoNamesORG.GET_CITY_BY_NAME)
        path.append(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        path.append(Constants.GeoNamesORG.MAX_ROWS)
        path.append("10")
        path.append(Constants.GeoNamesORG.KEY)
        return path
    }
}



