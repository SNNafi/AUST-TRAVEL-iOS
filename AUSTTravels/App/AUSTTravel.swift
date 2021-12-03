//
//  AUSTTravel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

class AUSTTravel: ObservableObject {
    
    @Published var currentAuthState: AuthState = .guest
    @Published var currentAuthPage: AuthStatePage = .signIn
    
}

