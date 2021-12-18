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
    
    @Published var becomeVolunteerValidator = BecomeVolunteerValidator()
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
    
    func isValidBecomeVolunteer(busName: String, phonNumber: String) -> Bool {
        if busName.isEmpty {
            becomeVolunteerValidator = BecomeVolunteerValidator(busNameErrorMessage: "Please select a bus name")
            return false
        }
        
        if phonNumber.isEmpty {
            becomeVolunteerValidator = BecomeVolunteerValidator(phoneNumberErrorMessage: "Please enter a phone number")
            return false
        }
        
        becomeVolunteerValidator = BecomeVolunteerValidator()
        return true
    }
    
    func createVolunteer(busName: String, phonNumber: String) async -> String {
        do {
            let snapshot = try await database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)/status").getData()
            if !snapshot.exists() {
                var dict = [String: Any]()
                dict["/volunteers/\(austTravel.currentUserUID!)/status"] = false
                dict["/users/\(austTravel.currentUserUID!)/settings/primaryBus"] = busName
                dict["/volunteers/\(austTravel.currentUserUID!)/contact"] = phonNumber
                try await database.reference().updateChildValues(dict)
                HapticFeedback.success.provide()
                return "We've received your request and will shortly review it."
            } else {
                if snapshot.value as! Bool {
                    HapticFeedback.success.provide()
                    return "You are already a volunteer! What else do you need?"
                } else {
                    HapticFeedback.success.provide()
                    return "Hey, hold your horses. We are reviewing your request!"
                }
            }
            
        } catch {
            HapticFeedback.error.provide()
            return "Something went wrong"
        }
    }
}


struct BecomeVolunteerValidator {
    var busNameErrorMessage: String?
    var phoneNumberErrorMessage: String?
}
