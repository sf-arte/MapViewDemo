//
//  ViewController.swift
//  MapViewDemo
//
//  Created by Suita Fujino on 2016/12/05.
//  Copyright © 2016年 ARTE Co., Ltd. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
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
    
    /// 領域の観測開始時の処理
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let alert = UIAlertController(title: "Notice", message: "監視開始", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 領域に入った時の処理
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Notice", message: "\(region.identifier)です", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 領域から出た時の処理
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Notice", message: "\(region.identifier)からでました", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// overlayの描画
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.lineWidth = 1.0
        renderer.fillColor = UIColor.lightGray
        renderer.strokeColor = UIColor.blue
        renderer.alpha = 0.5
        
        return renderer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        // 初期位置の設定
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.region.span = span
        
        /*
        stopMonitoring()
        
        // 監視する領域
        let shinbanbaRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(35.616494, 139.741501),
            radius: 200.0,
            identifier: "新馬場駅"
        )
        let seisekiRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(35.618927, 139.744431),
            radius: 50.0,
            identifier: "聖蹟公園"
        )
        let kitashinagawaRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(35.622281, 139.739302),
            radius: 450.0,
            identifier: "北品川駅"
        )
        
        locationManager.startMonitoring(for: shinbanbaRegion)
        locationManager.startMonitoring(for: seisekiRegion)
        locationManager.startMonitoring(for: kitashinagawaRegion)
        
        addCircleToMapView(region: shinbanbaRegion)
        addCircleToMapView(region: seisekiRegion)
        addCircleToMapView(region: kitashinagawaRegion)
        
        let keikyuStations = [
            "青物横丁駅" : CLLocationCoordinate2DMake(35.609328, 139.742937),
            "鮫洲駅" : CLLocationCoordinate2DMake(35.605069, 139.742339),
            "立会川駅" : CLLocationCoordinate2DMake(35.598559, 139.738929),
            "大森海岸駅" : CLLocationCoordinate2DMake(35.587684, 139.735390),
            "平和島駅" : CLLocationCoordinate2DMake(35.578757, 139.734968),
            "大森町駅" : CLLocationCoordinate2DMake(35.572419, 139.732003),
            "梅屋敷駅" : CLLocationCoordinate2DMake(35.566939, 139.728344),
            "京急蒲田駅" : CLLocationCoordinate2DMake(35.560809, 139.723817)
        ]
        
        for station in keikyuStations {
            let region = CLCircularRegion(center: station.value, radius: 200.0, identifier: station.key)
            locationManager.startMonitoring(for: region)
            addCircleToMapView(region: region)
        }
 
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// すべての監視を停止
    private func stopMonitoring() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    private func addCircleToMapView(region: CLCircularRegion) {
        let circle = MKCircle(center: region.center, radius: region.radius)
        mapView.add(circle)
    }
    
}

