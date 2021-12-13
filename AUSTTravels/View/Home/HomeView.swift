//
//  HomeView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import SPAlert

enum SelectionType {
    case liveTrack
    case shareLocation
}

struct HomeView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var homeViewModel = UIApplication.shared.homeViewModel
    @ObservedObject var locationManager = UIApplication.shared.locationManager
    @State private var isUserVolunteer: Bool = false
    @State private var volunteer: Volunteer? = nil
    @State private var selectionType: SelectionType = .liveTrack
    
    // LiveTrackView
    @State private var buses = [Bus]()
    @State private var selectedBusName: String = ""
    @State private var selectedBusTime: String = ""
    @State private var showBusSelect: Bool = false
    
    @State private var selectionError: Bool = false
    @State private var selectionErrorMessage: String = ""
    
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        
        ZStack {
            VStack {
                
                // MARK: - APP BAR
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack {
                        
                        Text("AUST TRAVELS")
                            .scaledFont(font: .sairaCondensedBold, dsize: 20)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15.dWidth())
                        Spacer()
                        
                        Icon(name: "gearshape.fill")
                            .systemImage()
                            .iconColor(.white)
                            .clickable {
                                withAnimation {
                                    austTravel.currentPage = .settings
                                }
                            }
                            .padding(.horizontal, 15.dWidth())
                        
                        
                    }
                    Spacer()
                }
                .frame(width: dWidth, height: 92.dHeight())
                .background(Color.green)
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            
                            ABButton(text: "LIVE TRACK BUS", textColor: .black, backgroundColor: .yellow, font: .sairaCondensedRegular) {
                                selectionType = .liveTrack
                                showBusSelect.toggle()
                            }
                            .rightIcon(Icon(name: "bus").iconColor(.black))
                            
                            ABButton(text: "VIEW ROUTES", textColor: .black, backgroundColor: .yellow, font: .sairaCondensedRegular) {
                                
                            }
                            .rightIcon(Icon(name: "view-routes").iconColor(.black))
                            
                            HStack {
                                Spacer()
                                Rectangle()
                                    .frame(width: dWidth * 0.3, height: 1.dWidth())
                                
                                Text("CONTRIBUTE")
                                    .scaledFont(font: .sairaCondensedLight, dsize: 15)
                                Rectangle()
                                    .frame(width: dWidth * 0.3, height: 1.dWidth())
                                Spacer()
                            }
                            .foregroundColor(.black)
                            .frame(width: dWidth * 0.9)
                            if isUserVolunteer {
                                ABButton(text: austTravel.isLocationSharing ? "STOP SHARING LOCATION" : "SHARE LOCATION", textColor: .white, backgroundColor: .redAsh, font: .sairaCondensedRegular) {
                                    if !austTravel.isLocationSharing {
                                        selectionType = .shareLocation
                                        showBusSelect.toggle()
                                    } else {
                                        stopWatch.resetTimer()
                                        homeViewModel.updateLocationSharing()
                                    }
                                    
                                }
                                .rightIcon(Icon(name: "map-location").iconColor(.black))
                            }
                            if austTravel.isLocationSharing {
//                                Text("\(locationManager.currentCoordinate.latitude) - \(locationManager.currentCoordinate.longitude)")
                                ZStack {
                                        RoundedRectangle(cornerRadius: 20.dHeight())
                                        .foregroundColor(.deepAsh)
                                    VStack {
                                        GeometryReader { gReader in
                                            VStack {
                                                Rectangle()
                                                    .frame(width: gReader.size.width, height: 60.dHeight(), alignment: .center)
                                                    .foregroundColor(.lightAsh)
                                                    .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
                                                    .overlay(Text("You are currently sharing your location for \(stopWatch.minute) : \(stopWatch.second)").scaledFont(font: .sairaCondensedSemiBold, dsize: 17).foregroundColor(.black))
                                                Text("Bus: \(selectedBusName)")
                                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 16).foregroundColor(.black)
                                                Text("Time: \(selectedBusTime)")
                                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 16).foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                                .frame(width: dWidth * 0.9, height: 140.dHeight())
                                .padding(10.dHeight())
                                .padding(.horizontal, 15.dHeight())
                            }
                            
                            ABButton(text: "VIEW VOLUNTEERS", textColor: .black, backgroundColor: .greenLight, font: .sairaCondensedRegular) {
                                
                            }
                            .rightIcon(Icon(name: "group").iconColor(.black))
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                if let volunteer = volunteer, let urlString = volunteer.userInfo.userImagePNG.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url =  URL(string: urlString) {
                                    
                                    ABURLImage(imageURL: url)
                                        .frame(width: 23.dWidth(), height: 23.dWidth(), alignment: .center)
                                        .padding(.trailing, 3.dWidth())
                                }
                                
                                Text(volunteer?.userInfo.email ?? "")
                                    .foregroundColor(.black)
                                    .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                    .padding(.trailing, 3.dWidth())
                                Spacer()
                            }
                            .frame(height: 85.dHeight(), alignment: .center)
                            .background(Color.gray.opacity(0.3))
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .onAppear {
                    
                    homeViewModel.fetchBusInfo { busList in
                        buses = busList
                    }
                    
                    homeViewModel.getVolunteerInfo { volunteer, error in
                        self.volunteer = volunteer
                        if let status = volunteer?.status {
                            isUserVolunteer = status
                        }
                    }
                    
                }
            }
            .background(Color.white)
            
            if showBusSelect {
                SelectBusDailogue(isBusTimeDropDownShown: true, buses: $buses, selectedBusName: $selectedBusName, selectedBusTime: $selectedBusTime, display: $showBusSelect) {
                    if selectedBusTime.isEmpty {
                        selectionErrorMessage = "Ahh, you must select a time dear!"
                        selectionError = true
                    } else if selectionType == .liveTrack {
                        withAnimation {
                            austTravel.selectedBusName = selectedBusName
                            austTravel.selectedBusTime = selectedBusTime
                            austTravel.currentPage = .liveTrack
                        }
                        
                    } else if selectionType == .shareLocation{
                        homeViewModel.updateLocationSharing()
                        stopWatch.startTimer()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .spAlert(isPresent: $selectionError, message: selectionErrorMessage, duration: 1.0, dismissOnTap: true, haptic: .error)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            print("App in background")
            // stop sharing location
        }
        .onReceive(locationManager.$currentCoordinate) { currentCoordinate in
            if austTravel.isLocationSharing {
                print(currentCoordinate)
                homeViewModel.updateBusLocation(selectedBusName: austTravel.selectedBusName, selectedBusTime: austTravel.selectedBusTime, currentCoordinate)
            }
        }
        .valueChanged(value: selectedBusName) { _ in
            selectedBusTime = ""
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
