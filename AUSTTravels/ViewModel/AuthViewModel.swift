//
//  AuthViewModel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class AuthViewModel: ObservableObject {
    
    var userUID: String?
    var userInfo: UserInfo?
    var user: User?
    
    func signUp(userInfo: UserInfo, password: String, completion: @escaping (Bool?, Error?) -> Void) {
        let auth =  Auth.auth()
        auth.createUser(withEmail: userInfo.email, password: password) { [weak self] authResult, error in
            guard let self = self, let user = auth.currentUser else {  completion(nil, error); return }
            self.userUID = user.uid
            self.saveNewUserInfo(for: userInfo, user: user)
            completion(self.sendVerificationEmail(), nil)
        }
    }
    
    @discardableResult
    private func saveNewUserInfo(for userInfo: UserInfo, user: User) -> Bool {
        var success = false
        let database = Database.database()
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = userInfo.userName
        if let photoURL =  URL(string: userInfo.userImage) {
            changeRequest.photoURL = photoURL
        }
        changeRequest.commitChanges { error in
            guard error == nil else { print("saveNewUserInfo", error!.localizedDescription); return }
            database.reference(withPath: "users/\(user.uid)").setValue(userInfo)
            success = true
        }
        return success
    }
    
    private func sendVerificationEmail() -> Bool {
        var success = false
        guard let user = Auth.auth().currentUser else { return false }
        user.sendEmailVerification { error in
            if error == nil  {
                success = true
                try? Auth.auth().signOut()
            }
        }
        return success
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool?, Error?) -> Void) {
        let auth =  Auth.auth()
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self, let user = auth.currentUser else { completion(nil, error); return }
            self.user = user
            completion(user.isEmailVerified, nil)
        }
    }
}
