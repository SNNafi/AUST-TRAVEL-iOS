//
//  User.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import Defaults

struct UserInfo: Codable, Defaults.Serializable {
    var email: String = ""
    var userName: String = ""
    var semester: String = ""
    var department: String = ""
    var universityId: String = ""
    
    var userImage: String { "https://avatars.dicebear.com/api/bottts/\(userName).svg" }

}

extension Defaults.Keys {
    static let userInfo = Key<UserInfo>("userInfo", default: .init(email: "", userName: "", semester: "", department: "", universityId: ""))
}
