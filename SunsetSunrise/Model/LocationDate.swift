//
//  Location.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

struct Coordinates {
    var latitude: String
    var longitude: String
}

struct LocationDate {
    var adress: String
    var coordinates: Coordinates
    var date: String
    var timeDifference: Int
}
