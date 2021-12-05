//
//  HomeView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var homeViewModel = UIApplication.shared.homeViewModel
    @ObservedObject var locationManager = UIApplication.shared.locationManager
    @State var isUserVolunteer: Bool = false
    @State var volunteer: Volunteer? = nil
    
    var body: some View {
        
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
                            print("HomeView")
                            austTravel.logOut()
                        }
                        .padding(.horizontal, 15.dWidth())
                    
                    
                }
                Spacer()
            }
            
            .frame(width: dWidth, height: 90.dHeight())
            .background(Color.green)
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        
                        ABButton(text: "LIVE TRACK BUS", textColor: .black, backgroundColor: .yellow, font: .sairaCondensedRegular) {
                            
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
                                
                                homeViewModel.updateLocationSharing()
                            }
                            .rightIcon(Icon(name: "map-location").iconColor(.black))
                        }
                        if austTravel.isLocationSharing {
                            Text("\(locationManager.currentCoordinate.latitude) - \(locationManager.currentCoordinate.longitude)")
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
                homeViewModel.getVolunteerInfo { volunteer, error in
                    self.volunteer = volunteer
                    if let status = volunteer?.status {
                        isUserVolunteer = status
                    }
                 }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            print("App in background")
            // stop sharing location
        }
        .onReceive(locationManager.$currentCoordinate) { currentCoordinate in
            if austTravel.isLocationSharing {
                print(currentCoordinate)
                
                // homeViewModel.updateBusLocation(selectedBusName: "Jamuna", selectedBusTime: "6:30AM", currentCoordinate)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
