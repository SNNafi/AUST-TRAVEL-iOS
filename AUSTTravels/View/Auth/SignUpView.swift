//
//  SignUpView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import SPAlert

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
    
    @State private var task: Task<Void, Error>? = nil
    @State private var isLoading: Bool = false
    @State private var authError: Bool = false
    @State private var authErrorMessage: String? = ""
    
    var body: some View {
        ZStack  {
            Color.white
            VStack {
                VStack {
                    Spacer()
                    Spacer()
                    HStack {
                        Icon(name: "back")
                            .iconColor(.white)
                            .clickable {
                                withAnimation {
                                    austTravel.currentAuthPage = .signIn
                                }
                            }
                            .padding(.horizontal, 15.dWidth())
                            .padding(.trailing, 3.dWidth())
                        
                        Text("SIGN UP")
                            .scaledFont(font: .sairaCondensedBold, dsize: 25)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15.dWidth())
                        
                        Spacer()
                    }
                    
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
                            
                            
                            if isLoading {
                                ActivityIndicator(isAnimating: isLoading)
                                    .configure { $0.color = .green }
                                    .background(Color.white)
                                    .padding(15.dWidth())
                            } else {
                                
                                ABButton(text: "SIGN UP", textColor: .black, backgroundColor: .yellowLight, font: .sairaCondensedSemiBold) {
                                    var _userInfo = UserInfo()
                                    _userInfo.email = email
                                    _userInfo.userName = nickname
                                    _userInfo.universityId = uniId
                                    _userInfo.semester = selectedSemester
                                    _userInfo.department = selectedDepartment
                                    
                                    let userInfo = _userInfo
                                    
                                    if authViewModel.isValidSignUpInfo(userInfo: userInfo, password: password) {
                                        task = Task {
                                            isLoading = true
                                            if await authViewModel.signUp(userInfo: userInfo, password: password) {
                                                authErrorMessage = "Email verification link sent to your email"
                                            } else {
                                                authErrorMessage = "Something went wrong"
                                            }
                                            authError = true
                                            isLoading = false
                                        }
                                    } else {
                                        HapticFeedback.warning.provide()
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .spAlert(isPresent: $authError,
                                 title: authErrorMessage ?? "",
                                 message: nil,
                                 duration: 2,
                                 dismissOnTap: true,
                                 preset: authErrorMessage == "Something went wrong" ? .error : .done,
                                 haptic: authErrorMessage == "Something went wrong" ? .error : .success,
                                 layout: .init()) {
                            
                            austTravel.currentAuthPage = .signIn
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            task?.cancel()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
