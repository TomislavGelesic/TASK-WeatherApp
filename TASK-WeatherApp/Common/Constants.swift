//
//  Constants.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation


struct Constants{
    
    struct GeoNamesORG  {
        
        static let BASE = "https://secure.geonames.org/searchJSON?"
        
        static let GET_CITY_BY_NAME = "name_startsWith="
        
        static let MAX_ROWS = "&maxRows="
        
        static let KEY = "&username=tgelesic"
    }
    
//    https://secure.geonames.org/searchJSON?name_startsWith=Vienna&username=tgelesic
    
    
    struct OpenWeatherMapORG {
        
        static let BASE = "https://api.openweathermap.org/data/2.5/weather?"
        
        static let KEY = "&appid=" + "c89f972e8095d59db84f5e88b5ad621e"
        
        static let GET_CITY_BY_ID = "id="
        
        static let WITH_METRIC_UNITS = "&units=metric"
        
        static let WITH_IMPERIAL_UNITS = "&units=imperial"
    }
    
//    https://api.openweathermap.org/data/2.5/weather?q=Vienna,WV&appid=c89f972e8095d59db84f5e88b5ad621e&units=metric
    
//    https://api.openweathermap.org/data/2.5/weather?id=2761369&appid=c89f972e8095d59db84f5e88b5ad621e&units=metric

}


