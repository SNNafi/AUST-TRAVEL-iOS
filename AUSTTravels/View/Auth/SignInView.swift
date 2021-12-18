//
//  SignInView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Defaults
import SPAlert
import Defaults

struct SignInView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var authViewModel = UIApplication.shared.authViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailIsEditing: Bool = false
    @State private var passwordIsEditing: Bool = false
    @State private var isPasswordHIdden: Bool = true
    
    @State private var task: Task<Void, Error>? = nil
    @State private var isLoading: Bool = false
    @State private var authError: Bool = false
    @State private var authErrorMessage: String? = ""
    
    var body: some View {
        ZStack  {
            LinearGradient(colors: [.green, .green, .green, .greenLight], startPoint: .topLeading, endPoint: .bottomTrailing)
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Spacer()
                        Text("AUST BUS")
                            .scaledFont(font: .sairaCondensedBold, dsize: 51)
                            .foregroundColor(.white)
                        
                        ABTextField(placeholder: "Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .rightIcon(Icon(name: "envelope")
                                        .systemImage()
                                        .iconColor(.greenLight))
                            .textColor(.white)
                            .addValidator(austTravel.authViewModel.signInValidator.emailErrorMessage)
                        
                        ABTextField(placeholder: "Enter your password", text: $password)
                            .rightIcon(Icon(name: "lock.fill")
                                        .systemImage()
                                        .iconColor(.greenLight))
                            .textColor(.white)
                            .addValidator(authViewModel.signInValidator.passwordErrorMessage)
                            .secureField(true)
                        
                        if isLoading {
                            ActivityIndicator(isAnimating: isLoading)
                                .configure { $0.color = .yellow }
                                .background(Color.green)
                                .padding(15.dWidth())
                        } else {
                            
                            ABButton(text: "SIGN IN", textColor: .black, backgroundColor: .white, font: .sairaCondensedSemiBold) {
                                if authViewModel.isValidSignInInfo(email: email, password: password) {
                                    task = Task {
                                        isLoading = true
                                        let status = await authViewModel.signIn(email: email, password: password)
                                        if status == "Something went wrong" {
                                            HapticFeedback.error.provide()
                                            authErrorMessage = status
                                            authError = true
                                            isLoading = false
                                            return
                                        }
                                        guard status == "OK" else {
                                            HapticFeedback.warning.provide()
                                            authErrorMessage = status
                                            authError = true
                                            isLoading = false
                                            return
                                        }
                                        
                                        isLoading = false
                                        HapticFeedback.success.provide()
                                        
                                        austTravel.currentFirebaseUser = authViewModel.user
                                        austTravel.currentAuthPage = .none
                                        
                                    }
                                } else {
                                    HapticFeedback.warning.provide()
                                }
                                
                            }
                        }
                        
                        Button {
                            
                            withAnimation {
                                austTravel.currentAuthPage = .forgetPassword
                            }
                            
                        } label: {
                            HStack {
                                Spacer()
                                Text("Forgot your password?")
                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 14)
                                    .foregroundColor(.white)
                                
                            }
                            .frame(width: dWidth * 0.9)
                            .padding(0)
                        }
    
                        HStack {
                            Rectangle()
                                .frame(width: dWidth * 0.4, height: 2.dWidth())
                            Spacer()
                            Text("OR")
                                .scaledFont(font: .sairaCondensedSemiBold, dsize: 15)
                            Spacer()
                            Rectangle()
                                .frame(width: dWidth * 0.4, height: 2.dWidth())
                        }
                        .foregroundColor(.white)
                        .frame(width: dWidth * 0.9)
                        
                        ABButton(text: "SIGN UP WITH EMAIL", textColor: .black, backgroundColor: .yellow, font: .sairaCondensedSemiBold) {
                            
                            withAnimation {
                                austTravel.currentAuthPage = .signUp
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                }
            }
        }
        .spAlert(isPresent: $authError,
                 title: authErrorMessage ?? "",
                 message: nil,
                 duration: 2,
                 dismissOnTap: true,
                 preset: authErrorMessage == "OK" ? .done : .error,
                 haptic: .none,
                 layout: .init(),
                 completion: {
            
        })
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            task?.cancel()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
