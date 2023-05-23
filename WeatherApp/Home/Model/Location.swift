//
//  Location.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import Foundation
struct Location {
    var cityName:String
    var latitude:Double
    var longitute:Double
    init(cityName: String, latitude: Double, longitute: Double) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitute = longitute
    }
}
