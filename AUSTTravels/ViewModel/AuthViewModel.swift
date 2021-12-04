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
    @Published var signInValidator = SignInValidator()
    @Published var forgetPasswordValidator = ForgetPasswordValidator()
    
    func isValidSignInInfo(email: String, password: String) -> Bool {
        var success = true
        if signInValidator.isEmail(email) {
            signInValidator = SignInValidator(emailErrorMessage: nil, passwordErrorMessage: nil)
            if !signInValidator.isAustEmail(email) {
                signInValidator = SignInValidator(emailErrorMessage: "You must enter your institutional mail", passwordErrorMessage: nil)
                success = false
            }
            if password.isEmpty {
                signInValidator = SignInValidator(emailErrorMessage: nil, passwordErrorMessage: "Password cannot be empty")
                success = false
            }
        } else {
            signInValidator = SignInValidator(emailErrorMessage: "Please enter a valid email", passwordErrorMessage: nil)
            success = false
        }
        return success
    }
    
    func isValidForgetPasswordInfo(email: String) -> Bool {
        var success = true
        if forgetPasswordValidator.isEmail(email) {
            forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: nil)
            if !forgetPasswordValidator.isAustEmail(email) {
                forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: "You must enter your institutional mail")
                success = false
            }
        } else {
            forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: "Please enter a valid email")
            success = false
        }
        return success
    }
    
    func signUp(userInfo: UserInfo, password: String, completion: @escaping (Bool?, Error?) -> Void) {
        let auth =  Auth.auth()
        auth.createUser(withEmail: userInfo.email, password: password) { [weak self] authResult, error in
            if error != nil {
                completion(nil, error)
                return
            }
            if let self = self, let user = auth.currentUser {
                self.userUID = user.uid
                self.saveNewUserInfo(for: userInfo, user: user)
                completion(self.sendVerificationEmail(), nil)
            }
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
            if error != nil {
                completion(nil, error)
                return
            }
            if let self = self, let user = auth.currentUser {
                self.user = user
                completion(user.isEmailVerified, nil)
            }
        }
    }
}


struct SignInValidator {
     var emailErrorMessage: String?
     var passwordErrorMessage: String?
  

    func isEmail(_ email: String) -> Bool {
        let pattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email) {
            return true
        } else {
            return false
        }
            
    }
    
    func isAustEmail(_ email: String) -> Bool {
        if  email.split(separator: "@")[1] == "aust.edu" {
            return true
        } else {
            return false
        }
            
    }
}
struct ForgetPasswordValidator{
    
    var emailErrorMessage: String?
   
    func isEmail(_ email: String) -> Bool {
        let pattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email) {
            return true
        } else {
            return false
        }
            
    }
    
    func isAustEmail(_ email: String) -> Bool {
        if  email.split(separator: "@")[1] == "aust.edu" {
            return true
        } else {
            return false
        }
            
    }
}
