//
//  RequestSunInfo.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation

struct RequestURL {
    var url: URLComponents
    
    init (latitude:  Float, longitute: Float, date: String) {
        url = URLComponents()
        url.scheme = "https"
        url.host = "api.sunrise-sunset.org"
        url.path = "/json"
        url.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lng", value: String(longitute)),
            URLQueryItem(name: "date", value: date)
        ]
    }
    
}
