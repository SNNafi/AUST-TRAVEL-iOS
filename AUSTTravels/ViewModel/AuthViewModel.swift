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
import Defaults

class AuthViewModel: ObservableObject {
    
    var userUID: String?
    var userInfo: UserInfo?
    var user: User?
    @Published var signInValidator = SignInValidator()
    @Published var forgetPasswordValidator = ForgetPasswordValidator()
    @Published var signUpValidator = SignUpValidator()
    
    func isValidSignInInfo(email: String, password: String) -> Bool {
        if isEmail(email) {
            signInValidator = SignInValidator(emailErrorMessage: nil, passwordErrorMessage: nil)
            if !isAustEmail(email) {
                signInValidator = SignInValidator(emailErrorMessage: "You must enter your institutional mail", passwordErrorMessage: nil)
                return false
            }
            if password.isEmpty {
                signInValidator = SignInValidator(emailErrorMessage: nil, passwordErrorMessage: "Password cannot be empty")
                return false
            }
        } else {
            signInValidator = SignInValidator(emailErrorMessage: "Please enter a valid email", passwordErrorMessage: nil)
            return false
        }
        return true
    }
    
    func isValidForgetPasswordInfo(email: String) -> Bool {
        if isEmail(email) {
            forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: nil)
            if !isAustEmail(email) {
                forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: "You must enter your institutional mail")
                return false
            }
        } else {
            forgetPasswordValidator = ForgetPasswordValidator(emailErrorMessage: "Please enter a valid email")
            return false
        }
        return true
    }
    
    func isValidSignUpInfo(userInfo: UserInfo, password: String) -> Bool {
        if isEmail(userInfo.email) {
            signUpValidator = SignUpValidator(emailErrorMessage: nil, passwordErrorMessage: nil, nameErrorMessage: nil, uniIdErrorMessage: nil, semesterErrorMessage: nil, departmentErrorMessage: nil)
            if !isAustEmail(userInfo.email) {
                signUpValidator = SignUpValidator(emailErrorMessage: "You must enter your institutional mail")
                return false
            }
        } else {
            signUpValidator = SignUpValidator(emailErrorMessage: "Please enter a valid email")
            return false
        }
        
        if password.isEmpty {
            signUpValidator = SignUpValidator(passwordErrorMessage: "Password cannot be empty")
            return false
        }
        
        if !signUpValidator.validateName(userInfo.userName) {
            signUpValidator = SignUpValidator(nameErrorMessage: "Please enter a name of 20 characters")
            return false
        }
        
        if userInfo.universityId.isEmpty {
            signUpValidator = SignUpValidator(emailErrorMessage: nil, nameErrorMessage: nil, uniIdErrorMessage: "Please enter your university ID")
            return false
        }
        
        if userInfo.semester.isEmpty {
            signUpValidator = SignUpValidator(semesterErrorMessage: "Please enter your semester")
            return false
        }
        
        if userInfo.department.isEmpty {
            signUpValidator = SignUpValidator(departmentErrorMessage: "Please enter your department")
            return false
        }
        
        return true
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
    
    func logOut() {
        try? Auth.auth().signOut()
    }
}


struct SignInValidator {
    var emailErrorMessage: String?
    var passwordErrorMessage: String?
}

struct ForgetPasswordValidator{
    var emailErrorMessage: String?
}

struct SignUpValidator {
    var emailErrorMessage: String?
    var passwordErrorMessage: String?
    var nameErrorMessage: String?
    var uniIdErrorMessage: String?
    var semesterErrorMessage: String?
    var departmentErrorMessage: String?
    
    func validateName(_ name: String) -> Bool {
        !name.isEmpty && !(name.count > 20)
    }
}


extension AuthViewModel {
    private func isEmail(_ email: String) -> Bool {
        let pattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email) {
            return true
        } else {
            return false
        }
        
    }
    
    private func isAustEmail(_ email: String) -> Bool {
        if  email.split(separator: "@")[1] == "aust.edu" {
            return true
        } else {
            return false
        }
        
    }
}
