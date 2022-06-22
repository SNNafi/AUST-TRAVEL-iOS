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
    @Published var deleteUserValidator = DeleteUserValidator()
    private var database = Database.database()
    let austTravel = SceneDelegate.austTravel
    
    func fetchBusInfo() async -> [Bus] {
        var buses = [Bus]()
        do {
            let snapshot = try await  database.reference(withPath: "availableBusInfo").getData()
            snapshot.children.forEach { dict in
                let snap = dict as! DataSnapshot
                var bus = Bus()
                bus.name = String(snap.key)
                snap.children.forEach { dict in
                    bus.timing.append(BusTiming(snapshot: dict as! DataSnapshot))
                }
                buses.append(bus)
            }
            return buses
        } catch { return buses }
    }
    
    func deleteAccount(password: String) {
        
    }
    
    func getUserSeetings() async -> UserSettings? {
        do {
            
            let snapshot = try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings").getData()
            if snapshot.exists() {
                let userSettings = UserSettings(snapshot: snapshot)
                print(userSettings)
                Defaults[.userSettings] = userSettings
                return userSettings
            }
            return nil
        } catch { return nil }
    }
    
    func updatePrimaryBus(_ primaryBus: String) async {
        guard primaryBus != "None" else { return }
        
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/primaryBus").setValue(primaryBus)
            
            // Update subscription after change primary bus
            try await unsubscribeFromPingBuses()
            try await unsubscribeFromLocationBuses()
            
            // Ping Notification
            if Defaults[.pingNotification] {
                await updatePingNotificationStatus(true)
            }
            
            // Local Notification
            if Defaults[.locationNotification] {
                await updateLocationNotificationStatus(true)
            }
            
        } catch { }
    }
    
    func updatePingNotificationStatus(_ isPingNotification: Bool) async {
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isPingNotification").setValue(isPingNotification)
            
            let primaryBus = Defaults[.primaryBus]
            if isPingNotification && primaryBus != "None" {
                try await Messaging.messaging().subscribe(toTopic: primaryBus)
                print(#function, "subscribed", primaryBus)
            } else if !isPingNotification && primaryBus != "None" {
                try await Messaging.messaging().unsubscribe(fromTopic: primaryBus)
                print(#function, "unsubscribed", primaryBus)
            }
            
        } catch { }
    }
    
    func updateLocationNotificationStatus(_ isLocationNotification: Bool) async {
        do {
            try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings/isLocationNotification").setValue(isLocationNotification)
            
            let primaryBus = Defaults[.primaryBus]
            
            if isLocationNotification && primaryBus != "None" {
                try await Messaging.messaging().subscribe(toTopic: "\(primaryBus)_USER")
                print(#function, "subscribed", "\(primaryBus)_USER")
            } else if !isLocationNotification && primaryBus != "None" {
                try await Messaging.messaging().unsubscribe(fromTopic: "\(primaryBus)_USER")
                print(#function, "unsubscribed", "\(primaryBus)_USER")
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
            
            workUponSigningOUT()
            
            await austTravel.logOut()
            
        } catch { }
    }
    
    func isValidDeleteAccount(password: String) -> Bool {
        if password.isEmpty {
            deleteUserValidator = DeleteUserValidator(passwordErrorMessage: "Password can not be empty")
            return false
        }
        deleteUserValidator = DeleteUserValidator()
        return true
    }
    
    func deleteUser(password: String) async -> String {
        do {
            let credential = EmailAuthProvider.credential(withEmail: austTravel.currentUser!.email, password: password)
            let authDataResult = try await Auth.auth().currentUser!.reauthenticate(with: credential)
            
            var dict = [String: Any]()
            dict["/users/\(austTravel.currentUserUID!)"] = nil
            dict["/volunteers/\(austTravel.currentUserUID!)"] = nil
            
            try await database.reference().updateChildValues(dict)
            try await authDataResult.user.delete()
            
            workUponSigningOUT()
            
            return "Your account has been deleted!"
            
        } catch { return "Couldn't delete your account at the moment. Please try again later" }
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
    
    private func workUponSigningOUT() {
        Defaults[.isShowAlertAboutPing] = true
        Defaults[.volunteer] = Volunteer()
        Defaults[.userSettings] = UserSettings()
        Defaults[.userInfo] = UserInfo()
        Defaults[.userEmail] = nil
        Defaults[.userPhotoURL] = nil
        Defaults[.pingNotification] = false
        Defaults[.locationNotification] = false
        Defaults[.primaryBus] = "None"
    }
}


struct BecomeVolunteerValidator {
    var busNameErrorMessage: String?
    var phoneNumberErrorMessage: String?
}

struct DeleteUserValidator {
    var passwordErrorMessage: String?
}
