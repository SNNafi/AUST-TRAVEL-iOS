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
    @State private var selectedBusName: String = "" {
        didSet {
            austTravel.selectedBusName = oldValue
        }
    }
    @State private var selectedBusTime: String = ""  {
        didSet {
            austTravel.selectedBusTime = oldValue
        }
    }
    @State private var showBusSelect: Bool = false
    
    @State private var selectionError: Bool = false
    @State private var selectionErrorMessage: String = ""
    
    // StopWatch
    @State private var timer: Timer?
    @State private var progressTime = 0
    @State private var isRunning = false
    
    var hour: Int {
        progressTime / 3600
    }
    
    var minute: Int {
        (progressTime % 3600) / 60
    }
    
    var second: Int {
        progressTime % 60
    }
    
    @State var pingError: Bool = false
    @State var pingErrorMessage: String = ""
    
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
                                        updateTimer()
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
                                                    .frame(width: gReader.size.width, height: 70.dHeight(), alignment: .center)
                                                    .foregroundColor(.lightAsh)
                                                    .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
                                                    .overlay(Text("You are currently sharing your location for\n \(hour) : \(minute) : \(second)").lineLimit(nil).multilineTextAlignment(.center).scaledFont(font: .sairaCondensedSemiBold, dsize: 19).foregroundColor(.black).fixedSize().padding(5.dHeight()))
                                                    .offset(y: -3.dHeight())
                                                Text("Bus: \(selectedBusName)")
                                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 17).foregroundColor(.black)
                                                Text("Time: \(selectedBusTime)")
                                                    .scaledFont(font: .sairaCondensedSemiBold, dsize: 17).foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                                .frame(width: dWidth * 0.9, height: 150.dHeight())
                                .padding(10.dHeight())
                                .padding(.horizontal, 15.dHeight())
                                .onAppear {
                                    Task {
                                        await homeViewModel.sendLocationNotification(busName: selectedBusName, busTime: selectedBusTime)
                                    }
                                }
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
                    print(austTravel.currentUserUID!)
                    
                    homeViewModel.fetchBusInfo { busList in
                        buses = busList
                    }
                    
                    Task {
                        await homeViewModel.getVolunteerInfo()
                        volunteer = austTravel.currentVolunteer
                        print(austTravel.currentVolunteer.status)
                        isUserVolunteer = austTravel.currentVolunteer.status
                        if let (status, message) = await homeViewModel.subscribeToPingNotification() as? (Bool, String) {
                            (pingError, pingErrorMessage) = (status, message)
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
                        updateTimer()
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
                homeViewModel.updateBusLocation(selectedBusName: selectedBusName, selectedBusTime: selectedBusTime, currentCoordinate)
            }
        }
        .valueChanged(value: selectedBusName) { _ in
            selectedBusTime = ""
        }
    }
    
    func updateTimer() {
        if isRunning{
            timer?.invalidate()
            homeViewModel.updateContribution(elapsedTime: progressTime)
            progressTime = 0
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                progressTime += 1
            })
        }
        isRunning.toggle()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
