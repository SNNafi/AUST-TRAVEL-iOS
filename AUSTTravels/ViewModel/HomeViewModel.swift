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

class HomeViewModel: ObservableObject {
    
    var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    func getVolunteerInfo(completion: @escaping (Volunteer?, Error?) -> ()) {
        
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)").getData { error, snapshot in
            if error != nil {
                completion(nil, error)
                return
            }
           
            var volunteer = Volunteer()
            guard let dict = snapshot.value as? NSDictionary else { return }
            volunteer.contact = dict["contact"] as? String ?? ""
            volunteer.status = dict["status"] as? Bool ?? false
            volunteer.totalContribution = dict["totalContribution"] as? Int ?? 0
            
        }
    }
}


