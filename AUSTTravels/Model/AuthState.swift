//
//  AuthState.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

enum AuthState {
    case logIn
    case guest
}


enum AuthStatePage {
    case none
    case signIn
    case signUp
    case forgetPassword
}
