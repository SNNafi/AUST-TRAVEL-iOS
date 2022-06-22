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
    @State private var loggingOut: Bool = false
    @State private var settingsError: Bool = false
    @State private var settingsErrorMessage: String? = ""
    @State private var isFetching: Bool = true
    @State private var underConstructionError: Bool = false
    
    @State private var showDeleteUser: Bool = false
    @State private var password: String = ""
    
    var body: some View {
        ZStack  {
            Color.white
            if isFetching {
                ActivityIndicator(isAnimating: isFetching)
                    .configure { $0.color = .green }
                    .frame(width: 50.dWidth(), height: 50.dWidth(), alignment: .center)
                    .background(Color.white)
            } else {
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
                                    underConstructionError = true
                                } label: {
                                    Text("Contributors")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.black)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    showDeleteUser = true
                                } label: {
                                    Text("Delete Account")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.redAsh)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    Task {
                                        task?.cancel()
                                        loggingOut = true
                                        await settingsViewModel.logOut()
                                        loggingOut = false
                                    }
                                } label: {
                                    if loggingOut {
                                        HStack {
                                            Spacer()
                                            ActivityIndicator(isAnimating: loggingOut)
                                                .configure { $0.color = .green }
                                                .background(Color.white)
                                                .padding(15.dWidth())
                                            Spacer()
                                        }
                                        
                                    } else {
                                    Text("Log Out")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.greenLight)
                                    }
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
            
            if showDeleteUser {
                DeleteUserDailogue(display: $showDeleteUser, password: $password, isLoading: $isLoading) {
                    if settingsViewModel.isValidDeleteAccount(password: password) {
                        task = Task {
                            isLoading = true
                            settingsErrorMessage = await settingsViewModel.deleteUser(password: password)
                            isLoading = false
                            showDeleteUser.toggle()
                            settingsError = true
                            austTravel.currentAuthPage = .signIn
                        }
                    }
                }
            }
        }
        .spAlert(isPresent: $settingsError, message: settingsErrorMessage ?? "", duration: 3)
        .spAlert(isPresent: $underConstructionError, message: "Under construction")
        .edgesIgnoringSafeArea(.all)
        .valueChanged(value: pingNotification) { _ in
            Task {
                await settingsViewModel.updatePingNotificationStatus(pingNotification)
            }
        }
        .valueChanged(value: locationNotification) { _ in
            Task {
                await settingsViewModel.updateLocationNotificationStatus(locationNotification)
            }
        }
        .valueChanged(value: primaryBus) { _ in
            Task {
                await settingsViewModel.updatePrimaryBus(primaryBus)
            }
        }
        .onAppear {
            task = Task {
                isFetching = true
                buses = await settingsViewModel.fetchBusInfo()
                if let userSettings = await settingsViewModel.getUserSeetings() {
                    pingNotification = userSettings.isPingNotification
                    locationNotification = userSettings.isLocationNotification
                    primaryBus = userSettings.primaryBus
                }
                isFetching = false
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
