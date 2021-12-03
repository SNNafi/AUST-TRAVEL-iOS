//
//  SignInView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import iTextField

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailIsEditing: Bool = false
    @State private var passwordIsEditing: Bool = false
    @State private var isPasswordHIdden: Bool = true
    @State private var selectedItem: String = ""
    
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
                        
                        HStack {
                            Image("user")
                                .resizable()
                                .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
                            
                            iTextField("Enter your email", text: $email, isEditing: $emailIsEditing)
                                .fontFromUIFont(GenericFont.loadDUIFont(font: .sairaCondensedRegular, size: 17))
                                .keyboardType(.emailAddress)
                                .returnKeyType(.next)
                                .onReturn { passwordIsEditing = true }
                                .foregroundColor(.white)
                                .frame(height: 47.dHeight())
                        }
                        .frame(width: dWidth * 0.85)
                        .padding(10.dHeight())
                        .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(emailIsEditing ? Color.black : Color.white, lineWidth: 1.dWidth()))
                        .padding(.horizontal, 15.dHeight())
                        
                        HStack {
                            Image("user")
                                .resizable()
                                .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
                            
                            
                            iTextField("Enter your password", text: $password, isEditing: $passwordIsEditing)
                                .fontFromUIFont(GenericFont.loadDUIFont(font: .sairaCondensedRegular, size: 17))
                                .keyboardType(.default)
                                .returnKeyType(.done)
                                .isSecure(isPasswordHIdden)
                                .onReturn { passwordIsEditing = false }
                                .foregroundColor(.white)
                                .frame(height: 47.dHeight())
                            
                            Button {
                                isPasswordHIdden.toggle()
                            } label: {
                                Image(systemName: isPasswordHIdden ? "eye.fill" : "eye.slash.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(height: 14.dWidth(), alignment: .center)
                            }
                            
                        }
                        .frame(width: dWidth * 0.85)
                        .padding(10.dHeight())
                        .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(passwordIsEditing ? Color.black : Color.white, lineWidth: 1.dWidth()))
                        .padding(.horizontal, 15.dHeight())
                        
                        
                        ABButton(text: "SIGN IN", textColor: .black, backgroundColor: .white, font: .sairaCondensedSemiBold) {
                            
                        }
                       
                        
                        Button {
                            
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
                            
                        }
                        
                        
                        Spacer()
                        
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
