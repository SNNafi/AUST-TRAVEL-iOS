//
//  HomeViewModel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
import Defaults
import CoreLocation.CLLocation
import FirebaseMessaging

class HomeViewModel: ObservableObject {
    
    private var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    @discardableResult
    func updateLocationSharing() -> Bool {
        
        if austTravel.isLocationSharing {
            austTravel.locationManager.stopUpdatingLocation()
        } else {
            austTravel.locationManager.startUpdatingLocation()
        }
        
        austTravel.isLocationSharing.toggle()
        return austTravel.isLocationSharing
    }
    
    func getVolunteerInfo() async {
        
        do {
            let vSnapshot = try await database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)").getData()
            if vSnapshot.exists() {
                if let dict = vSnapshot.value as? NSDictionary  {
                    var volunteer = Volunteer()
                    volunteer.contact = dict["contact"] as? String ?? ""
                    volunteer.status = dict["status"] as? Bool ?? false
                    volunteer.totalContribution = dict["totalContribution"] as? Int ?? 0
                    Defaults[.volunteer] = volunteer
                }
            }
            
            let uSnapshot = try await database.reference(withPath: "users/\(self.austTravel.currentUserUID!)").getData()
            
            if let dict = uSnapshot.value as? NSDictionary {
                var userInfo = UserInfo()
                userInfo.department = dict["department"] as? String ?? ""
                userInfo.email = dict["email"] as? String ?? ""
                userInfo.userName = dict["name"] as? String ?? ""
                userInfo.semester = dict["semester"] as? String ?? ""
                userInfo.universityId = dict["universityId"] as? String ?? ""
                
                Defaults[.volunteer].userInfo = userInfo
                Defaults[.userInfo] = userInfo
            }
            
        } catch {
            
        }
    }
    
    func updateBusLocation(selectedBusName: String, selectedBusTime: String, _ currentCoordinate: CLLocationCoordinate2D) {
        
        var dict = [String: String]()
        dict["lat"] = String(currentCoordinate.latitude)
        dict["long"] = String(currentCoordinate.longitude)
        dict["lastUpdatedTime"] = String(Int(Date().timeIntervalSince1970 * 1000))
        dict["lastUpdatedVolunteer"] = austTravel.currentUserUID!
        dict["universityId"] = austTravel.currentUser!.universityId
        database.reference(withPath: "bus/\(selectedBusName)/\(selectedBusTime)/location")
            .setValue(dict)
    }
    
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
    
    func updateContribution(elapsedTime: Int) {
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)/totalContribution").keepSynced(true)
        var previousContribution = 0
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)/totalContribution").getData { [weak self] error, snapshot in
            guard let self = self else {  return }
            if error != nil {
                return
            }
            
            if snapshot.exists() {
                previousContribution = (snapshot.value as! Int)
                print("previousContribution", previousContribution)
            }
            
            let totalTimeElapsed = previousContribution + (elapsedTime * 1000)
            print("totalTimeElapsed", totalTimeElapsed)
            self.database.reference(withPath: "volunteers/\(self.austTravel.currentUserUID!)/totalContribution").setValue(totalTimeElapsed)
        }
    }
    
    func subscribeToPingNotification() async -> Any {
        do {
            let snapshot = try await database.reference(withPath: "users/\(austTravel.currentUserUID!)/settings").getData()
            let userSettings = UserSettings(snapshot: snapshot)
            Defaults[.userSettings] = userSettings
            if Defaults[.volunteer].status {
                
                try await Messaging.messaging().subscribe(toTopic: userSettings.primaryBus)
                if Defaults[.isShowAlertAboutPing] {
                    Defaults[.isShowAlertAboutPing].toggle()
                    return (true, "You will receive ping notifications from \(userSettings.primaryBus) whenever someone pings you.")
                }
                return ""
            } else {
                try await Messaging.messaging().unsubscribe(fromTopic: userSettings.primaryBus)
                return ""
            }
        } catch { return ""}
    }
    
    func sendLocationNotification(busName: String, busTime: String) async {
        do {
            let primaryBus = Defaults[.userSettings].primaryBus
            if primaryBus == busName {
                try await Messaging.messaging().unsubscribe(fromTopic: "\(busName)_USER")
            }
            
            guard var url = URL(string: Constant.sendUser) else { return }
            url.appendQueryItem(name: "bus", value: "\(busName)_USER")
            url.appendQueryItem(name: "title", value: "\(busName) \(busTime) is now live")
            url.appendQueryItem(name: "message", value: "\(Defaults[.userInfo].userName) is sharing their location. Track them now to know where the bus is headed!")
            
            try await URLSession.shared.data(from: url)
            
            if primaryBus == busName {
                try await Messaging.messaging().subscribe(toTopic: "\(busName)_USER")
            }
            
        } catch { }
    }
}


