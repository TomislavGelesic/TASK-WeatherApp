//
//  GeoNameResponse.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 16.01.2021..
//

import UIKit

struct GeoNameResponse: Codable {
    
    let geonames: [GeoNameItem]
    
    init(from decoder: Decoder) throws {
        
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        try geonames = rootContainer.decode([GeoNameItem].self, forKey: .geonames)
        
//        var container = try rootContainer.nestedUnkeyedContainer(forKey: GeoNameItem.CodingKeys.self)
//        let geonames = [GeoNameItem]()
//
//        while !container.isAtEnd {
//
//            let item = container.de
//        }
        
    }
}

extension GeoNameResponse {

    enum CodingKeys: CodingKey {

        case geonames
    }
}
