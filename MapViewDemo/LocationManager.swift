//
//  LocationManager.swift
//  MapViewDemo
//
//  Created by Suita Fujino on 2016/12/14.
//  Copyright © 2016年 ARTE Co., Ltd. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()

    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startMonitoring() {
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    /// 位置情報の更新に成功した時の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        let eventDate = last.timestamp
        if abs(eventDate.timeIntervalSinceNow) < 15.0 {
            if let location = manager.location {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if error != nil { return }
                    guard let placemark = placemarks?[0] else { return }
                    
                    let content = UNMutableNotificationContent()
                    content.title = "現在地"
                    content.body = "\(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.subLocality ?? "") です。"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "foo", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
    }
    
    /// 位置情報の更新に失敗した時の処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
