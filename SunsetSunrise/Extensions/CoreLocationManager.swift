//
//  CoreLocationManager.swift
//  SunsetSunrise
//
//  Created by Sebastian on /19/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import CoreLocation

protocol CoreLocDelegate: class {
    func getCoordinates(location: CLLocation)
    func alertLocationAccess()
}

class CoreLocationManadger:  NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    weak var delegate: CoreLocDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation//kCLLocationAccuracyBest
    }
    
    func startTracking() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .denied:
            delegate!.alertLocationAccess()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopTracking() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate!.getCoordinates(location: locations[0])
    }
}
