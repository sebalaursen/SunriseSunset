//
//  ModelController.swift
//  SunsetSunrise
//
//  Created by Sebastian on /18/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import Foundation
import CoreLocation

class ModelController {
    var locationDate = LocationDate(adress: "", coordinates: Coordinates(latitude: "", longitude: ""), date: "", timeDifference: 0)
    var sunInfo = SunInfo(sunrise: "", sunset: "", solar_noon: "", day_length: "")
    
    func updateTime() {
        print(sunInfo.sunset)
        print(sunInfo.sunrise)
        print(sunInfo.solar_noon)
        sunInfo.sunset = format(time: sunInfo.sunset)
        sunInfo.sunrise = format(time: sunInfo.sunrise)
        sunInfo.solar_noon = format(time: sunInfo.solar_noon)
    }
    
    private func format(time: String) -> String {
        var res = ""
        let dateString = "20-04-2019 \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
            print(locationDate.timeDifference)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: locationDate.timeDifference)
            res = dateFormatter.string(from: dateFromString)
        }
        let index = res.firstIndex(of: " ")!
        res = String(res[index...])
        return res
        
    }
    
    func getTimeZone() {
        let latitude = Double(locationDate.coordinates.latitude)!
        let longitude = Double(locationDate.coordinates.longitude)!
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
            guard let placemark = placemarks?[0], let _ = placemarks?[0].timeZone else {
                return
            }
            self.locationDate.timeDifference = placemark.timeZone!.secondsFromGMT()
        }
    }
}
