//
//  SignUpView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var authViewModel = UIApplication.shared.authViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var nickname: String = ""
    @State private var uniId: String = ""
    @State private var selectedSemester: String = ""
    @State private var selectedDepartment: String = ""
    @State private var emailIsEditing: Bool = false
    @State private var passwordIsEditing: Bool = false
    @State private var nicknameIsEditing: Bool = false
    @State private var uniIdIsEditing: Bool = false
    @State private var isPasswordHIdden: Bool = true
    
    var body: some View {
        ZStack  {
            Color.white
            
            VStack {
                VStack {
                    Spacer()
                    Spacer()
                    Text("SIGN UP")
                        .scaledFont(font: .sairaCondensedBold, dsize: 25)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                .frame(width: dWidth, height: 120.dHeight())
                .background(Color.green)
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Rectangle()
                                .frame(height: 15.dHeight())
                                .foregroundColor(.clear)
                            
                            ABTextField(placeholder: "Enter your institutional email", text: $email)
                                .keyboardType(.emailAddress)
                                .rightIcon(Icon(name: "envelope")
                                            .systemImage()
                                            .iconColor(.black))
                                .textColor(.black)
                                .borderColor(.black)
                                .addValidator(authViewModel.signUpValidator.emailErrorMessage)
                            
                            
                            ABTextField(placeholder: "Enter your password", text: $password)
                                .rightIcon(Icon(name: "lock.fill")
                                            .systemImage()
                                            .iconColor(.black))
                                .textColor(.black)
                                .borderColor(.black)
                                .addValidator(authViewModel.signUpValidator.passwordErrorMessage)
                                .secureField(true)
                            
                            
                            ABTextField(placeholder: "Enter your nickname", text: $nickname)
                                .rightIcon(Icon(name: "person.circle.fill")
                                            .systemImage()
                                            .iconColor(.black))
                                .textColor(.black)
                                .borderColor(.black)
                                .addValidator(authViewModel.signUpValidator.nameErrorMessage)
                            
                            ABTextField(placeholder: "Enter your university ID", text: $uniId)
                                .rightIcon( Icon(name: "id-card")
                                                .iconColor(.black))
                                .textColor(.black)
                                .borderColor(.black)
                                .addValidator(authViewModel.signUpValidator.uniIdErrorMessage)
                            
                            DropDown(icon: "semester", placeholder: "Select your semester", itemList: ["1.1", "1.2", "2.1", "2.2", "3.1", "3.2", "4.1", "4.2", "5.1", "5.2"], selectedItem: $selectedSemester)
                                .itemTextColor(.black)
                                .selectedBorderColor(.green)
                                .addValidator(authViewModel.signUpValidator.semesterErrorMessage)
                            
                            DropDown(icon: "department", placeholder: "Select your department", itemList: ["CSE", "EEE", "CE", "TE", "MPE", "ARCH", "BBA"], selectedItem: $selectedDepartment)
                                .itemTextColor(.black)
                                .selectedBorderColor(.green)
                                .addValidator(authViewModel.signUpValidator.departmentErrorMessage)
                            
                            ABButton(text: "SIGN UP", textColor: .black, backgroundColor: .yellowLight, font: .sairaCondensedSemiBold) {
                                var userInfo = UserInfo()
                                userInfo.email = email
                                userInfo.userName = nickname
                                userInfo.universityId = uniId
                                userInfo.semester = selectedSemester
                                userInfo.department = selectedDepartment
                                
                                if authViewModel.isValidSignUpInfo(userInfo: userInfo, password: password) {
                                    
                                } else {
                                    HapticFeedback.warning.provide()
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
