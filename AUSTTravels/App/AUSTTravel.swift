//
//  AUSTTravel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Defaults
import FirebaseAuth

class AUSTTravel: ObservableObject {
    
    @Published var currentAuthState: AuthState = Defaults[.authState]
    @Published var currentAuthPage: AuthStatePage = Defaults[.authStatePage]
    let authViewModel = AuthViewModel()
    var userId: String?
    var currentFirebaseUser: User?
    var currentUser: UserInfo?
}

