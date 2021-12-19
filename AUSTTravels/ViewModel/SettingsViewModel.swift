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
import FirebaseMessaging
import CollectionConcurrencyKit

class SettingsViewModel: ObservableObject {
    
    @Published var becomeVolunteerValidator = BecomeVolunteerValidator()
    private var database = Database.database()
    let austTravel = SceneDelegate.austTravel
    
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
    
    func updatePrimaryBus(_ primaryBus: String) async {
        guard primaryBus != "None" else { return }
        
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/primaryBus").setValue(primaryBus)
            
            // Update subscription after change primary bus
            try await unsubscribeFromPingBuses()
            
            if Defaults[.pingNotification] {
                try await Messaging.messaging().subscribe(toTopic: primaryBus)
            }
            
        } catch { }
    }
    
    func updatePingNotificationStatus(_ isPingNotification: Bool) async {
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isPingNotification").setValue(isPingNotification)
            
            let primaryBus = Defaults[.primaryBus]
            if isPingNotification && primaryBus != "None" {
                try await Messaging.messaging().subscribe(toTopic: primaryBus)
            } else if !isPingNotification && primaryBus != "None" {
                try await Messaging.messaging().unsubscribe(fromTopic: primaryBus)
            }
            
        } catch { }
    }
    
    func updateLocationNotificationStatus(_ isLocationNotification: Bool) async {
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isLocationNotification").setValue(isLocationNotification)
            
            let primaryBus = Defaults[.primaryBus]
            
            if isLocationNotification && primaryBus != "None" {
                try await Messaging.messaging().subscribe(toTopic: "\(primaryBus)_USER")
            } else if !isLocationNotification && primaryBus != "None" {
                try await Messaging.messaging().unsubscribe(fromTopic: "\(primaryBus)_USER")
            }
            
        } catch { }
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
    
    func logOut() async {
        
        do {
            let primaryBus = Defaults[.userSettings].primaryBus
            try await Messaging.messaging().unsubscribe(fromTopic: primaryBus)
            try await Messaging.messaging().unsubscribe(fromTopic: "\(primaryBus)_USER")
            Defaults[.isShowAlertAboutPing] = true
            Defaults[.volunteer] = Volunteer()
            Defaults[.userSettings] = UserSettings()
            Defaults[.userInfo] = UserInfo()
            Defaults[.userEmail] = nil
            Defaults[.userPhotoURL] = nil
            Defaults[.pingNotification] = false
            Defaults[.locationNotification] = false
            Defaults[.primaryBus] = "None"
            austTravel.logOut()
            
        } catch { }
    }
    
    private func unsubscribeFromPingBuses() async throws {
        var buses = [String]()
        let snapshot = try await database.reference(withPath: "availableBusInfo").getData()
        snapshot.children.forEach { dict in
            let snap = dict as! DataSnapshot
            buses.append(String(snap.key))
        }
        try await buses.asyncForEach { bus in
            try await Messaging.messaging().unsubscribe(fromTopic: bus)
        }
    }
    
    private func unsubscribeFromLocationBuses() async throws {
        var buses = [String]()
        let snapshot = try await database.reference(withPath: "availableBusInfo").getData()
        snapshot.children.forEach { dict in
            let snap = dict as! DataSnapshot
            buses.append(String(snap.key))
        }
        try await buses.asyncForEach { bus in
            try await Messaging.messaging().unsubscribe(fromTopic: "\(bus)_USER")
        }
    }
}


struct BecomeVolunteerValidator {
    var busNameErrorMessage: String?
    var phoneNumberErrorMessage: String?
}
