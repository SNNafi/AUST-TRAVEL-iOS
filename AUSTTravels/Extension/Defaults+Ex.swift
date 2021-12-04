//
//  Defaults+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import Defaults

extension Defaults.Keys {
    
    static let userUid = Key<String?>("userUid", default: nil)
    static let userEmail = Key<String?>("userEmail", default: nil)
    static let userPhotoURL = Key<String?>("userPhotoURL", default: nil)
}
