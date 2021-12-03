//
//  AuthState.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Defaults

enum AuthState: Int, Defaults.Serializable {
    case logIn = 1
    case guest = 0
}


enum AuthStatePage: Int, Defaults.Serializable {
    case none = 0
    case signIn = 1
    case signUp = 2
    case forgetPassword = 3
}

extension Defaults.Keys {
    static let authState  = Key<AuthState>("authState", default: .guest)
    static let authStatePage  = Key<AuthStatePage>("authStatePage", default: .signIn)
}
