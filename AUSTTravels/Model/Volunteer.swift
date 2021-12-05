//
//  Volunteer.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import Defaults

struct Volunteer: Codable, Defaults.Serializable  {
    var userInfo: UserInfo = UserInfo()
    var totalContribution: Int = 0
    var status: Bool = false
    var contact: String = ""
}

extension Defaults.Keys {
    static let volunteer = Key<Volunteer>("volunteer", default: .init(userInfo: UserInfo(), totalContribution: 0, status: false, contact: ""))
}
