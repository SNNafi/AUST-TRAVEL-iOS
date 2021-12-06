//
//  MapViewController.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import GoogleMaps
import GoogleMapsUtils
import SwiftUI
import UIKit

class MapViewController: UIViewController {
    
    let map =  GoogleMaps.GMSMapView(frame: .zero)
    var clusterManager: GMUClusterManager!
    var isAnimating: Bool = false
    let camera = GMSCameraPosition.camera(withLatitude: 23.763879, longitude:  90.406258, zoom: 12.5)
    
    override func viewDidLoad() {
        
        map.camera = camera
        map.settings.myLocationButton = false
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.isMyLocationEnabled = true
    }
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
}
