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

class HomeViewModel: ObservableObject {
    
    var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    func getVolunteerInfo(completion: @escaping (Volunteer?, Error?) -> ()) {
        
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)").getData { [weak self] error, snapshot in
            guard let self = self else { return }
            if error != nil {
                completion(nil, error)
                return
            }
            
            var volunteer = Volunteer()
            guard let dict = snapshot.value as? NSDictionary else { return }
            volunteer.contact = dict["contact"] as? String ?? ""
            volunteer.status = dict["status"] as? Bool ?? false
            volunteer.totalContribution = dict["totalContribution"] as? Int ?? 0
            
            self.database.reference(withPath: "users/\(self.austTravel.currentUserUID!)").getData { error, snapshot in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let dict = snapshot.value as? NSDictionary else { return }
                var userInfo = UserInfo()
                userInfo.department = dict["department"] as? String ?? ""
                userInfo.email = dict["email"] as? String ?? ""
                userInfo.userName = dict["name"] as? String ?? ""
                userInfo.semester = dict["semester"] as? String ?? ""
                userInfo.universityId = dict["universityId"] as? String ?? ""
                
                volunteer.userInfo = userInfo
                Defaults[.userInfo] = userInfo
                
                self.austTravel.currentUser = userInfo
                self.austTravel.currentVolunteer = volunteer
                
                completion(volunteer, nil)
            }
        }
    }
}


