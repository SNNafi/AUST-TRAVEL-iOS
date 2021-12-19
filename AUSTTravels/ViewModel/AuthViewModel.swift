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
import UIKit

class AuthViewModel: ObservableObject {
    
    var userUID: String?
    var userInfo: UserInfo?
    var user: User?
    @Published var signInValidator = SignInValidator()
    @Published var forgetPasswordValidator = ForgetPasswordValidator()
    @Published var signUpValidator = SignUpValidator()
    
    private let austTravel = SceneDelegate.austTravel
    private let auth =  Auth.auth()
    
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
    
    func signUp(userInfo: UserInfo, password: String) async -> Bool {
        do {

            let authDataResulr = try await auth.createUser(withEmail: userInfo.email, password: password)
            user = authDataResulr.user
            austTravel.currentFirebaseUser = authDataResulr.user
            try await saveNewUserInfo(for: userInfo, user: authDataResulr.user)
            try await sendVerificationEmail()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    private func saveNewUserInfo(for userInfo: UserInfo, user: User) async throws -> Bool {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = userInfo.userName
        if let photoURL =  URL(string: userInfo.userImage) {
            changeRequest.photoURL = photoURL
        }
        try await changeRequest.commitChanges()
        var dict = [String: Any]()
        dict["department"] = userInfo.department
        dict["email"] = userInfo.email
        dict["name"] = userInfo.userName
        dict["semester"] = userInfo.semester
        dict["universityId"] = userInfo.universityId
        dict["userImage"] = userInfo.userImage
        try await Database.database().reference(withPath: "users/\(austTravel.currentUserUID!)").setValue(dict)
        return true
    }
    
    @discardableResult
    private func sendVerificationEmail() async throws -> Bool {
        guard let user = auth.currentUser else { return false }
        try await user.sendEmailVerification()
        try Auth.auth().signOut()
        return true
    }
    
    func signIn(email: String, password: String) async -> String {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            user = authDataResult.user
            if authDataResult.user.isEmailVerified {
                return "OK"
            } else {
                return "Please verify your email"
            }
        } catch {
            return "Something went wrong"
        }
    }
    
    func forgetPassword(email: String) async -> String {
        do {
        try await auth.sendPasswordReset(withEmail: email)
            return "An email is sent to your institutional email"
        } catch {
            return "Something went wrong"
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
