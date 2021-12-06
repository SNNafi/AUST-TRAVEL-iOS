//
//  LiveTrackViewModel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
import Defaults
import CoreLocation.CLLocation
import GoogleMaps.GMSMarker
import SwiftUI

class LiveTrackViewModel: ObservableObject {
    
    var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    func fetchBusRoutes(busName: String, busTime: String, completion: @escaping (([Route]) -> ())) {
        var routes = [Route]()
        
        database.reference(withPath: "bus/\(busName)/\(busTime)/routes").getData { error, snapshot in
            if error != nil {
                completion(routes)
                return
            }
            
            snapshot.children.forEach { dict in
                let route = Route(snapshot: dict as! DataSnapshot)
                routes.append(route)
            }
            completion(routes)
        }
    }
    
    func initialBusMarker() -> GMSMarker {
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 23.763879, longitude: 90.406258))
        marker.title = nil
        marker.userData = nil
        marker.tracksViewChanges = false
        marker.iconView = UIHostingController(rootView: Image("bus-marker").resizable().scaledToFit()).view
        marker.iconView?.frame = CGRect(x: 0, y: 0, width: 80.dWidth() , height: 80.dWidth())
        marker.iconView?.backgroundColor = UIColor.clear
        return marker
    }
    
    func createRouteMarkers(_ routes: [Route]) -> [GMSMarker] {
        var markers = [GMSMarker]()
        routes.forEach { route in
            let marker = GMSMarker(position: route.coordinate)
            marker.title = route.place
            
           // marker.icon = UIHostingController(rootView: MapInfoView(route: route)).view.asImage()
            marker.icon = nil
            marker.userData = route
            marker.tracksViewChanges = false
            marker.tracksInfoWindowChanges = false
            marker.infoWindowAnchor = CGPoint(x: 0, y: 0)
            marker.iconView = UIHostingController(rootView: Image("traffic-right-turn").resizable().scaledToFit()).view
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: 35.dWidth() , height: 35.dWidth())
            marker.iconView?.backgroundColor = UIColor.clear
            markers.append(marker)
        }
       
        return markers
    }
    
}
