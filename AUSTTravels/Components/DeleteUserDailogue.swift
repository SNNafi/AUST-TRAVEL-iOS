//
//  DeleteUserDailogue.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 21/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct DeleteUserDailogue: View {
    
    
    @ObservedObject var settingsViewModel = UIApplication.shared.settingsViewModel
    @Binding var display: Bool
    @Binding var password: String
    @Binding var isLoading: Bool
    var action: () -> () = { }
    @State private var frontPage: Bool = true
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            ZStack {
                RoundedRectangle(cornerRadius: 20.dHeight())
                    .foregroundColor(.white)
                
                if frontPage {
                    VStack {
                        GeometryReader { gReader in
                            VStack {
                                Rectangle()
                                    .frame(width: gReader.size.width, height: 60.dHeight(), alignment: .center)
                                    .foregroundColor(.yellowLight)
                                    .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
                                    .overlay(Text("WARNING").scaledFont(font: .sairaCondensedSemiBold, dsize: 20).foregroundColor(.black))

                                VStack {
                                    Text(" Deleting your account will result in all of your personal data being removed from your servers. This action is  ") + Text("irreversible").fontWeight(.bold) + Text(" and we advice you to think twice before deleting the account.")
                                }
                                .multilineTextAlignment(.center)
                                .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                .foregroundColor(.black)
                                .padding(15.dWidth())
                                
                                Button {
                                    frontPage.toggle()
                                } label: {
                                    Text("I CONFIRM")
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 16)
                                        .foregroundColor(.white)
                                        .frame(width: gReader.size.width * 0.75, height: 50.dHeight(), alignment: .center)
                                }
                                .background(Color.redAsh)
                                
                                HStack {
                                    Spacer()
                                    Circle()
                                        .frame(width: 10.dWidth(), height: 10.dWidth(), alignment: .center)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 2.dWidth())
                                    Circle()
                                        .frame(width: 10.dWidth(), height: 10.dWidth(), alignment: .center)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(10.dHeight())
                                
                            }
                        }
                    }
                } else {
                    VStack {
                        GeometryReader { gReader in
                            VStack {
                                Rectangle()
                                    .frame(width: gReader.size.width, height: 60.dHeight(), alignment: .center)
                                    .foregroundColor(.yellowLight)
                                    .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
                                    .overlay(Text("RE-AUTHENTICATE YOURSELF").scaledFont(font: .sairaCondensedSemiBold, dsize: 18).foregroundColor(.black))
                                
                                ABTextField(placeholder: "Enter your password", text: $password)
                                    .rightIcon(Icon(name: "phone.fill").systemImage().iconColor(.black))
                                    .textColor(.black)
                                    .secureField(true)
                                    .width(gReader.size.width * 0.75)
                                    .addValidator(settingsViewModel.deleteUserValidator.passwordErrorMessage)
                                
                                if isLoading {
                                    ActivityIndicator(isAnimating: isLoading)
                                        .configure { $0.color = .green }
                                        .background(Color.white)
                                        .padding(15.dWidth())
                                } else {
                                    Button {
                                        action()
                                    } label: {
                                        Text("CONFIRM")
                                            .scaledFont(font: .sairaCondensedRegular, dsize: 16)
                                            .foregroundColor(.white)
                                            .frame(width: gReader.size.width * 0.75, height: 50.dHeight(), alignment: .center)
                                    }
                                    .background(Color.green)
                                    .padding(.top, 3.dHeight())
                                }
                                HStack {
                                    Spacer()
                                    Circle()
                                        .frame(width: 10.dWidth(), height: 10.dWidth(), alignment: .center)
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 2.dWidth())
                                    Circle()
                                        .frame(width: 10.dWidth(), height: 10.dWidth(), alignment: .center)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10.dHeight())
                            }
                        }
                    }
                }
            }
            .frame(width: dWidth * 0.8, height: dHeight * 0.28)
            
        }
        .frame(width: dWidth, height: dHeight, alignment: .center)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture(count: 2) {
            display.toggle()
        }
    }
}

//struct BecomeVolunteerDailogue_Previews: PreviewProvider {
//    static var previews: some View {
//        BecomeVolunteerDailogue()
//    }
//}
