//
//  ViewController.swift
//  MapViewDemo
//
//  Created by Suita Fujino on 2016/12/05.
//  Copyright © 2016年 ARTE Co., Ltd. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    /// 位置情報の更新に成功した時の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            mapView.setCenter(location.coordinate, animated: true)
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
        
        stopMonitoring()
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
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        // 初期位置の設定
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.region.span = span
        
        stopMonitoring()
        
        // 監視する領域
        let shinbanbaRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(35.616494, 139.741501),
            radius: 200.0,
            identifier: "新馬場駅"
        )
        let seisekiRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(35.618927, 139.744431),
            radius: 200.0,
            identifier: "聖蹟公園"
        )
        
        locationManager.startMonitoring(for: shinbanbaRegion)
        locationManager.startMonitoring(for: seisekiRegion)
        
        let shinbanbaCircle = MKCircle(center: shinbanbaRegion.center, radius: shinbanbaRegion.radius)
        let seisekiCircle = MKCircle(center: seisekiRegion.center, radius: seisekiRegion.radius)
        mapView.add(shinbanbaCircle)
        mapView.add(seisekiCircle)
        
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
    
    
}

