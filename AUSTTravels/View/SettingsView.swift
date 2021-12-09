//
//  SettingsView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Defaults

struct SettingsView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    
    @Default(.pingNotification) var pingNotification
    @Default(.locationNotification) var locationNotification
    @Default(.primaryBus) var primaryBus
    
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
                                    //  austTravel.currentAuthPage = .signIn
                                }
                            }
                            .padding(.horizontal, 15.dWidth())
                            .padding(.trailing, 3.dWidth())
                        
                        Text("SETTINGS")
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
                            HStack {
                                VStack {
                                    Text("Ping Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                    Text("If you don’t want to receive any ping notifications, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedBold, dsize: 14)
                                    
                                }
                                Toggle("", isOn: $pingNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack {
                                    Text("Location Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                    Text("If you don’t want to receive any notifications when someone is sharing their location, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedBold, dsize: 14)
                                    
                                }
                                Toggle("", isOn: $pingNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            VStack {
                                Button {
                                    
                                } label: {
                                    Text("Privacy & Policy")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Contributors")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Delete Account")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                        .foregroundColor(.redAsh)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    austTravel.logOut()
                                } label: {
                                    Text("Log Out")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                        .foregroundColor(.greenLight)
                                }
                                .padding(3.dHeight())
                            }
                            
                            
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
