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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
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
        
        // 初期位置の設定
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.region.span = span
        
        LocationManager.sharedInstance.startMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

