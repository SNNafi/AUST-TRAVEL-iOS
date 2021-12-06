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
    
}
