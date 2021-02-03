//
//  UserLocationResponse.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 02.02.2021..
//

import Foundation

struct UserLocationResponse: Codable {
    var geonames: [Geoname]
}

struct Geoname: Codable {
    var name, lat, lng: String
    var geonameId, countryCode, countryName: String
}
