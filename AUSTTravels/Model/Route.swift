//
//  Route.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import CoreLocation
import FirebaseDatabase

struct Route {
    var place: String = ""
    var estTime: String = ""
    var mapPlaceName: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    init(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? NSDictionary else {
                return
        }
        place = dict["place"] as? String ?? ""
        mapPlaceName = dict["mapPlaceName"] as? String ?? ""
        estTime = dict["estTime"] as? String ?? ""
        let latitude = dict["latitude"] as? Double ?? 0
        let longitude = dict["longitude"] as? Double ?? 0
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    
}
