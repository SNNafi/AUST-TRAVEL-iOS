//
//  SettingsView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Defaults
import SPAlert

struct SettingsView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var settingsViewModel = UIApplication.shared.settingsViewModel
    
    @Default(.volunteer) var volunteer
    @Default(.pingNotification) var pingNotification
    @Default(.locationNotification) var locationNotification
    @Default(.primaryBus) var primaryBus
    
    @State private var buses = [Bus]()
    @State private var selectedBusTime: String = ""
    @State private var showBusSelect: Bool = false
    @State private var phoneNumber: String = ""
    @State private var showbecomeVolunteer: Bool = false
    
    @State private var task: Task<Void, Error>? = nil
    @State private var isLoading: Bool = false
    @State private var settingsError: Bool = false
    @State private var settingsErrorMessage: String? = ""
    
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
                                    austTravel.currentPage = .home
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
                .frame(width: dWidth, height: 90.dHeight())
                .background(Color.green)
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            if !volunteer.status {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Become a volunteer")
                                            .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        Text("Contribute to the community by routinely sharing your location")
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.leading)
                                            .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                        
                                    }
                                    .foregroundColor(.black)
                                    Spacer()
                                }
                                .clickable {
                                    showbecomeVolunteer = true
                                }
                                .padding(3.dHeight())
                                
                                
                                Divider()
                                    .foregroundColor(.black)
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Ping Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("If you don’t want to receive any ping notifications, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Toggle("", isOn: $pingNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Location Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("If you don’t want to receive any notifications when someone is sharing their location, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Toggle("", isOn: $locationNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Primary Bus")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("Currently set to: \(primaryBus)")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Button {
                                        showBusSelect.toggle()
                                } label: {
                                    Text("CHANGE")
                                        .scaledFont(font: .sairaCondensedSemiBold, dsize: 20)
                                        .foregroundColor(.green)
                                }
                                
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading) {
                                Button {
                                    withAnimation {
                                        austTravel.currentPage = .privacyPolicy
                                    }
                                } label: {
                                    Text("Privacy & Policy")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.black)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Contributors")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.black)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Delete Account")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.redAsh)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    task = Task {
                                        await settingsViewModel.logOut()
                                    }
                                } label: {
                                    Text("Log Out")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.greenLight)
                                }
                                .padding(3.dHeight())
                            }
                            
                            Spacer()
                        }
                        .padding(10)
                        .padding(.horizontal, 10)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            if showBusSelect {
                SelectBusDailogue(buses: $buses, selectedBusName: $primaryBus, selectedBusTime: $selectedBusTime, display: $showBusSelect)
                    .transition(.scale)
            }
            if showbecomeVolunteer {
                BecomeVolunteerDailogue(display: $showbecomeVolunteer, buses: $buses, selectedBusName: $primaryBus, phoneNumber: $phoneNumber, isLoading: $isLoading) {
                    if settingsViewModel.isValidBecomeVolunteer(busName: primaryBus, phonNumber: phoneNumber) {
                        
                        task = Task {
                            isLoading = true
                            settingsErrorMessage = await settingsViewModel.createVolunteer(busName: primaryBus, phonNumber: phoneNumber)
                            isLoading = false
                            showbecomeVolunteer.toggle()
                            settingsError = true
                        }
                        
                    }
                }
            }
        }
        .spAlert(isPresent: $settingsError, message: settingsErrorMessage ?? "", duration: 3)
        .edgesIgnoringSafeArea(.all)
        .valueChanged(value: pingNotification) { _ in
            task = Task {
                await settingsViewModel.updatePingNotificationStatus(pingNotification)
            }
        }
        .valueChanged(value: locationNotification) { _ in
            task = Task {
                await settingsViewModel.updateLocationNotificationStatus(locationNotification)
            }
        }
        .valueChanged(value: primaryBus) { _ in
            task = Task {
                await settingsViewModel.updatePrimaryBus(primaryBus)
            }
        }
        .onAppear {
            settingsViewModel.fetchBusInfo { busList in
                buses = busList
            }
            settingsViewModel.getUserSeetings { userSettings, _ in
                if let userSettings = userSettings {
                    pingNotification = userSettings.isPingNotification
                    locationNotification = userSettings.isLocationNotification
                    primaryBus = userSettings.primaryBus
                }
            }
        }
        .onDisappear {
            task?.cancel()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
