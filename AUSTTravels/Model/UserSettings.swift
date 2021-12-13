//
//  UserSettings.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 13/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import Defaults
import FirebaseDatabase

struct UserSettings: Codable, Defaults.Serializable {
    var isLocationNotification: Bool = false
    var isPingNotification: Bool = false
    var primaryBus: String = "None"
    
    init() { }
    
    init(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? NSDictionary else {
                return
        }
        isLocationNotification = dict["isLocationNotification"] as? Bool ?? false
        isPingNotification = dict["isPingNotification"] as? Bool ?? false
        primaryBus = dict["primaryBus"] as? String ?? ""
    }    
}

extension Defaults.Keys {
    static let userSettings = Key<UserSettings>("userSettings", default: .init())
}
