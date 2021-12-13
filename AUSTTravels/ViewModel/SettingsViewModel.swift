//
//  SettingsViewModel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 10/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
import Defaults
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    private var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    func fetchBusInfo(completion: @escaping ([Bus]) -> ()) {
        var buses = [Bus]()
        
        database.reference(withPath: "availableBusInfo").getData { error, snapshot in
            if error != nil {
                completion(buses)
                return
            }
           
            snapshot.children.forEach { dict in
                let snap = dict as! DataSnapshot
                var bus = Bus()
                bus.name = String(snap.key)
                snap.children.forEach { dict in
                    bus.timing.append(BusTiming(snapshot: dict as! DataSnapshot))
                }
                buses.append(bus)
            }
            completion(buses)
        }
    }
    
    func deleteAccount(password: String) {
        
    }
    
    func getUserSeetings(completion: @escaping (UserSettings?, Error?) -> Void) {
        database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings").getData { error, snapshot in
            if error != nil {
                completion(nil, error)
                return
            }
            if snapshot.exists() {
                let userSettings = UserSettings(snapshot: snapshot)
                print(userSettings)
                Defaults[.userSettings] = userSettings
                completion(userSettings, nil)
                return
            }
        }
    }
    
    func updatePrimaryBus(_ primaryBus: String) {
        do {
            database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/primaryBus").setValue(primaryBus)
        } catch {
            
        }
        
    }
    
    func updatePingNotificationStatus(_ isPingNotification: Bool) {
        do {
            database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isPingNotification").setValue(isPingNotification)
        } catch {
            
        }
       
    }
    
    func updateLocationNotificationStatus(_ isLocationNotification: Bool) {
        do {
            database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isLocationNotification").setValue(isLocationNotification)
        } catch {
            
        }
        
    }
}
