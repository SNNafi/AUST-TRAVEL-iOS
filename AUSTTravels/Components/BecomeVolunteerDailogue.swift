//
//  BecomeVolunteerDailogue.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 18/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct BecomeVolunteerDailogue: View {
    
    
    @ObservedObject var settingsViewModel = UIApplication.shared.settingsViewModel
    
    @Binding var display: Bool
    @Binding var buses: [Bus]
    @Binding var selectedBusName: String
    @Binding var phoneNumber: String
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
                                    .overlay(Text("Become a Volunteer").scaledFont(font: .sairaCondensedSemiBold, dsize: 20).foregroundColor(.black))
                                
                                VStack {
                                    Text("By becoming a volunteer, you will be responsible for sharing your location ") + Text("ONLY").fontWeight(.bold) + Text(" when you are on the bus. Your location data will be continuously shared with other relevant users while your location sharing is active.") + Text(" Do you wish to continue?").fontWeight(.bold)
                                }
                                .multilineTextAlignment(.center)
                                .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                .foregroundColor(.black)
                                .padding(15.dWidth())
                                
                                Button {
                                    frontPage.toggle()
                                } label: {
                                    Text("CONTINUE")
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 16)
                                        .foregroundColor(.white)
                                        .frame(width: gReader.size.width * 0.75, height: 50.dHeight(), alignment: .center)
                                }
                                
                                .background(Color.green)
                                
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
                                    .overlay(Text("Become a Volunteer").scaledFont(font: .sairaCondensedSemiBold, dsize: 18).foregroundColor(.black))
                                
                                VStack {
                                    Text("Choose the ") + Text("primary").fontWeight(.bold) + Text(" bus that you travel in")
                                }
                                .multilineTextAlignment(.center)
                                .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                .foregroundColor(.black)
                                .padding(10.dWidth())
                                
                                DropDown(icon: "bus", placeholder: "Select bus name", itemList: buses.map(\.name), selectedItem: $selectedBusName)
                                    .itemTextColor(.black)
                                    .selectedBorderColor(.green)
                                    .width(gReader.size.width * 0.75)
                                    .expandedList(dheight: 100)
                                    .addValidator(settingsViewModel.becomeVolunteerValidator.busNameErrorMessage)
                                
                                VStack {
                                    Text("Enter your contact number. ") + Text("We won’t share your contact with anyone.").fontWeight(.bold) + Text(" We’ll use this information only when it’s urgent")
                                }
                                .multilineTextAlignment(.center)
                                .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                .foregroundColor(.black)
                                .padding(10.dWidth())
                                
                                ABTextField(placeholder: "Enter your phone", text: $phoneNumber)
                                    .rightIcon(Icon(name: "phone.fill").systemImage().iconColor(.black))
                                    .textColor(.black)
                                    .width(gReader.size.width * 0.75)
                                    .addValidator(settingsViewModel.becomeVolunteerValidator.phoneNumberErrorMessage)
                                
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
            .frame(width: dWidth * 0.8, height: dHeight * (frontPage ? 0.46: 0.63))
            
        }
        .frame(width: dWidth, height: dHeight, alignment: .center)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            display.toggle()
        }
    }
}

//struct BecomeVolunteerDailogue_Previews: PreviewProvider {
//    static var previews: some View {
//        BecomeVolunteerDailogue()
//    }
//}
