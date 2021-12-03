//
//  SignUpView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
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
                            
                            HStack {
                                Icon(name: "envelope")
                                    .systemImage()
                                    .iconColor(.black)
                                
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .placeholder(when: $email.wrappedValue.isEmpty) {
                                        Text("Enter your institutional email")
                                    }
                                    .frame(height: 47.dHeight())
                                    .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                    .foregroundColor(.black)
                            }
                            .frame(width: dWidth * 0.85)
                            .padding(10.dHeight())
                            .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(emailIsEditing ? Color.green : Color.black, lineWidth: 1.dWidth()))
                            .padding(.horizontal, 15.dHeight())
                            
                            HStack {
                                Icon(name: "lock.fill")
                                    .systemImage()
                                    .iconColor(.black)
                            
                                if isPasswordHIdden {
                                    SecureField("", text: $password)
                                        .keyboardType(.default)
                                        .placeholder(when: $password.wrappedValue.isEmpty) {
                                            Text("Enter your password")
                                        }
                                        .frame(height: 47.dHeight())
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                        .foregroundColor(.black)
                                } else {
                                    TextField("", text: $password)
                                        .keyboardType(.default)
                                        .placeholder(when: $password.wrappedValue.isEmpty) {
                                            Text("Enter your password")
                                        }
                                        .frame(height: 47.dHeight())
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                        .foregroundColor(.black)
                                }
                                
                                Button {
                                    isPasswordHIdden.toggle()
                                } label: {
                                    Image(systemName: isPasswordHIdden ? "eye.fill" : "eye.slash.fill")
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFit()
                                        .foregroundColor(.black)
                                        .scaledToFit()
                                        .frame(height: 14.dWidth(), alignment: .center)
                                }
                                
                            }
                            .frame(width: dWidth * 0.85)
                            .padding(10.dHeight())
                            .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(passwordIsEditing ? Color.green : Color.black, lineWidth: 1.dWidth()))
                            .padding(.horizontal, 15.dHeight())
                            
                            HStack {
                                Icon(name: "person.circle.fill")
                                    .systemImage()
                                    .iconColor(.black)
                               
                                TextField("", text: $nickname)
                                    .keyboardType(.default)
                                    .placeholder(when: $nickname.wrappedValue.isEmpty) {
                                        Text("Enter your nickname")
                                    }
                                    .frame(height: 47.dHeight())
                                    .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                    .foregroundColor(.black)
                                
                            }
                            .frame(width: dWidth * 0.85)
                            .padding(10.dHeight())
                            .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(emailIsEditing ? Color.green : Color.black, lineWidth: 1.dWidth()))
                            .padding(.horizontal, 15.dHeight())
                            
                            HStack {
                                Icon(name: "id-card")
                                    .iconColor(.black)
                                
                                TextField("", text: $uniId)
                                    .keyboardType(.default)
                                    .placeholder(when: $uniId.wrappedValue.isEmpty) {
                                        Text("Enter your university ID")
                                    }
                                    .frame(height: 47.dHeight())
                                    .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                    .foregroundColor(.black)
                            }
                            .frame(width: dWidth * 0.85)
                            .padding(10.dHeight())
                            .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(emailIsEditing ? Color.green : Color.black, lineWidth: 1.dWidth()))
                            .padding(.horizontal, 15.dHeight())
                            
                            DropDown(icon: "semester", placeholder: "Select your semester", itemList: ["1.1", "1.2", "2.1", "2.2", "3.1", "3.2", "4.1", "4.2", "5.1", "5.2"], selectedItem: $selectedSemester)
                                .itemTextColor(.black)
                                .selectedBorderColor(.green)
                            
                            DropDown(icon: "department", placeholder: "Select your department", itemList: ["CSE", "EEE", "CE", "TE", "MPE", "ARCH", "BBA"], selectedItem: $selectedDepartment)
                                .itemTextColor(.black)
                                .selectedBorderColor(.green)
                            
                            ABButton(text: "SIGN UP", textColor: .black, backgroundColor: .yellowLight, font: .sairaCondensedSemiBold) {
                                
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
