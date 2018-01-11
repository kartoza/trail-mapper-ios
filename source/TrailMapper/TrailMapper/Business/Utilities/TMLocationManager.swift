//
//  TMLocationManager.swift
//  TrailMapper
//
//  Created by Netwin on 11/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class TMLocationManager: NSObject,CLLocationManagerDelegate {

    static var sharedInstance:TMLocationManager {
        struct Static  {
            static let instance:TMLocationManager = TMLocationManager()
        }
        return Static.instance
    }

    var locationManager = CLLocationManager() // for getting GPS coords
    var latestLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord

    override init() {
        super.init()

        self.locationManager = CLLocationManager()

        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        };

        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager.stopUpdatingLocation()
    }

    func startTrailingSectionUpdates() {
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }

    func stopTrailingSectionUpdates() {
        self.locationManager.stopMonitoringSignificantLocationChanges()
        self.locationManager.stopUpdatingLocation()
    }

    // MARK:- Core Location Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {
            return
        }
        self.latestLocationCoordinate = location.coordinate
        print("Coordinates: \(self.latestLocationCoordinate.latitude) ,  \(self.latestLocationCoordinate.longitude)")
    }

}
