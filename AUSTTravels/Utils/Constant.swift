//
//  Constant.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 19/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation

struct Constant {
    static let baseURL = "https://aust-travels.herokuapp.com"
    
    static var sendVolunteer: String {
        "\(baseURL)/send-volunteer"
    }
    
    static var sendUser: String {
        "\(baseURL)/send-users"
    }
}
