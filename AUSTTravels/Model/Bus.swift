//
//  Bus.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 10/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct BusTiming {
    var startTime: String = ""
    var departureTime: String = ""
    
    init() { }
    
    init(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? NSDictionary else {
                return
        }
        startTime = dict["startTime"] as? String ?? ""
        departureTime = dict["departureTime"] as? String ?? ""
    }
}

struct Bus {
    var name: String = ""
    var timing = [BusTiming]()
}
