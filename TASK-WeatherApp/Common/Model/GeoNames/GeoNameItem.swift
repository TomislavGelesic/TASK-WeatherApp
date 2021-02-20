//
//  GeoNameItem.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import Foundation

struct GeoNameItem: Codable {
    
    
    var name: String
    var countryName: String
    var lat: String
    var lng: String
    var countryCode: String
    var geonameId: Int
    
    
    init(name: String, countryName: String, lat: String, lng: String, countryCode: String, geonameId: Int) {
        self.name = name
        self.countryName = countryName
        self.lat = lat
        self.lng = lng
        self.countryCode = countryCode
        self.geonameId = geonameId
    }
}
