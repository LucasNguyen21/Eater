//
//  LocationHandler.swift
//  Eater
//
//  Created by Nguyen Dinh Thang on 11/5/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject {
    let locationManager = CLLocationManager()
    
    func requestAuthentication(){
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocationAddress(completionHandler: @escaping (CLPlacemark?) -> Void){
        if let location = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            }
        }
        else {
            completionHandler(nil)
        }
    }
    
    func getCurrentLocationLatLong(completionHandler: @escaping(_ currentLocation: CLLocation) -> Void){
        let currentLocation: CLLocation!
        if CLLocationManager.locationServicesEnabled(){
            if let location = locationManager.location {
                currentLocation = location
                completionHandler(currentLocation)
            }
        }
    }
}

extension LocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

