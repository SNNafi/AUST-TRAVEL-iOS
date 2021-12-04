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
    @Published var currentAuthPage: AuthStatePage = Defaults[.authStatePage] {
        didSet {
            if currentAuthPage != .signUp && currentAuthPage != .forgetPassword {
                Defaults[.authStatePage] = currentAuthPage
            }
        }
    }
    
    // MARK: - VIEW MODEL
    
    // We need to declare them as lazy otherwise, it will initialize while `SceneDelegate` doesn't exist causing crash !
    lazy var authViewModel = AuthViewModel()
    lazy var homeViewModel = HomeViewModel()
    
    
    
    var userId: String?
    var currentFirebaseUser: User? {
        didSet {
            Defaults[.userEmail] = currentFirebaseUser?.email
            Defaults[.userUid] = currentFirebaseUser?.uid
            Defaults[.userPhotoURL] = currentFirebaseUser?.photoURL?.absoluteString
            
        }
    }
    var currentUser: UserInfo?
    
    func logOut() {
        authViewModel.logOut()
        currentAuthPage = .signIn
    }
    
    var currentUserEmail: String? {
        Defaults[.userEmail]
    }
    
    var currentUserUID: String? {
        Defaults[.userUid]
    }
    
    var currentUserPhotoUrl: URL? {
       URL(string:  Defaults[.userPhotoURL] ?? "")
    }
}

