//
//  SunInfo.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

struct result: Decodable {
    let results: SunInfo
}

struct SunInfo: Decodable {
    var sunrise: String!
    var sunset: String!
    var solar_noon: String!
    var day_length: String!
}
