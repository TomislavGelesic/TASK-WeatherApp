//
//  Geoname.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 20.02.2021..
//

import Foundation

class Geoname {
    
    var id: String
    var name: String
    var countryName: String
    var latitude: String
    var longitude: String
    
    init(id: String = "", name: String = "", countryName: String = "", latitude: String = "", longitude: String = "") {
        self.id = id
        self.name = name
        self.countryName = countryName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ item: GeoNameItem) {
        self.id = String(item.geonameId)
        self.name = item.name
        self.countryName = item.countryName
        self.latitude = item.lat
        self.longitude = item.lng
    }
    
}
