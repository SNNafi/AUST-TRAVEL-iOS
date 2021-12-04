//
//  ForgotPasswordView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var authViewModel = UIApplication.shared.authViewModel
    @State private var email: String = ""
    @State private var emailIsEditing: Bool = false
    @State private var authError: Bool = false
    @State private var authErrorMessage: String? = nil
    
    var body: some View {
        ZStack  {
            Color.white
            
            VStack {
                VStack {
                    Spacer()
                    Spacer()
                    Text("FORGOT PASSWORD")
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
                            
                            Text("We’ll send you a password reset link if the email you provide exists in our database")
                                .multilineTextAlignment(.center)
                                .scaledFont(font: .sairaCondensedBold, dsize: 18)
                                .padding(.bottom, 2.dHeight())
                                .padding(.horizontal, 4.dWidth())
                            
                            ABTextField(placeholder: "Enter your institutional email", text: $email)
                                .keyboardType(.emailAddress)
                                .rightIcon(Icon(name: "envelope")
                                            .systemImage()
                                            .iconColor(.black))
                                .textColor(.black)
                                .borderColor(.green)
                                .addValidator(authViewModel.forgetPasswordValidator.emailErrorMessage)
                            
                            ABButton(text: "SEND", textColor: .black, backgroundColor: .yellowLight, font: .sairaCondensedSemiBold) {
                                if authViewModel.isValidForgetPasswordInfo(email: email) {
                                    print("true")
                                } else {
                                    print("false")
//                                    authErrorMessage =  austTravel.authViewModel.forgetPasswordValidator.emailErrorMessage
//                                    authError = true
                                }
                            }
                            .spAlert(isPresent: $authError,
                                     title: "Error !",
                                     message: authErrorMessage ?? "",
                                     duration: 1.2,
                                     dismissOnTap: true,
                                     preset: .custom(UIImage(systemName: "exclamationmark.triangle.fill")!),
                                     haptic: .error,
                                     layout: .init(),
                                     completion: {
                                
                            })
                            
                            Button {
                                
                                withAnimation {
                                    austTravel.currentAuthPage = .signIn
                                }
                                
                            } label: {
                                Text("RETURN BACK")
                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 18)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 3.dHeight())
                            .padding(.horizontal, 5.dWidth())
                            
                            
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
