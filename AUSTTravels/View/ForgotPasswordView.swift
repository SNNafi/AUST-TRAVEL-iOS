//
//  ForgotPasswordView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email: String = ""
    @State private var emailIsEditing: Bool = false
    
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
                            
                            HStack {
                                Image("user")
                                    .resizable()
                                    .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
                                
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
                        
                            ABButton(text: "SEND", textColor: .black, backgroundColor: .yellowLight, font: .sairaCondensedSemiBold) {
                                
                            }
                            
                            Button {
                                
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
