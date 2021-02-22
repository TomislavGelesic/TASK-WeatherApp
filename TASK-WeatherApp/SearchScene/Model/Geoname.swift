//
//  Geoname.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 20.02.2021..
//

import Foundation

class Geoname {
    
    var id: Int64
    var name: String
    var countryName: String
    var latitude: Double
    var longitude: Double
    
    init(id: Int64 = 0, name: String = "", countryName: String = "", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.id = id
        self.name = name
        self.countryName = countryName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ item: GeoNameItem) {
        self.id = Int64(item.geonameId)
        self.name = item.name
        self.countryName = item.countryName
        self.latitude = Double(item.lat) ?? 0.0
        self.longitude = Double(item.lng) ?? 0.0
    }
    
}
