//
//  LiveTrackView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct LiveTrackView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var liveTrackViewModel = UIApplication.shared.liveTrackViewModel
    
    @State private var currentLocation: CLLocation?
    @State private var busLatestMarker: GMSMarker?
    @State private var busRoutes = [GMSMarker]()
    var selectedBus: String = "Jamuna"
    var selectedBusTime: String = "6:30AM"
    
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Icon(name: "back")
                        .iconColor(.white)
                        .clickable {
                            
                        }
                        .padding(.horizontal, 10.dWidth())
                        .padding(.trailing, 3.dWidth())
                    
                    
                    Text("LIVE TRACK")
                        .scaledFont(font: .sairaCondensedBold, dsize: 20)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15.dWidth())
                    Spacer()
                    
                    Icon(name: "gearshape.fill")
                        .systemImage()
                        .iconColor(.white)
                        .clickable {
                            
                            //                            austTravel.logOut()
                        }
                        .padding(.horizontal, 15.dWidth())
                    
                    
                }
                Spacer()
            }
            .frame(width: dWidth, height: 92.dHeight())
            .background(Color.green)
            
            GoogleMapView(busLatestMarker: $busLatestMarker, markers: $busRoutes, currentLocation: $currentLocation) { marker in
                print(#function)
                return true
            }
           // .frame(width: dWidth, height: 490.dHeight(), alignment: .top)
            VStack {
                Rectangle()
                    .frame(width: dWidth * 0.3, height: 1.dWidth())
                    .foregroundColor(.white)
                    .padding(.top, 5.dHeight())
                
                HStack {
                    Text("Selected Bus: ")
                        .scaledFont(font: .sairaCondensedBold, dsize: 21)
                        .foregroundColor(.white)
                    
                    Text(selectedBus)
                        .scaledFont(font: .sairaCondensedSemiBold, dsize: 21)
                        .foregroundColor(.white)
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("PING")
                        .scaledFont(font: .sairaCondensedBold, dsize: 21)
                        .foregroundColor(.yellow)
                    }

                }
                .padding(.horizontal, 15.dWidth())
                .padding(.top, 2.dWidth())
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15.dWidth())
                        .foregroundColor(.white)
                        
                    VStack {
                        Text("Starting time: ")
                            .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                            .foregroundColor(.black)
                        Text("Arrival time: ")
                            .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                            .foregroundColor(.black)
                        Text("Departure time: ")
                            .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.vertical, 1.dWidth())
                .padding(.horizontal, 15.dWidth())
                .frame(width: dWidth, height: 132.dHeight())
                
                
                Spacer()
                
            }
            .frame(width: dWidth, height: 230.dHeight())
            .background(Color.green)
            .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
            
            
        }
        .background(Color.redAsh)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 23.763879, longitude: 90.406258))
            marker.title = nil
            marker.userData = nil
            marker.tracksViewChanges = false
            marker.iconView = UIHostingController(rootView: Image("bus-marker").resizable().scaledToFit()).view
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: 80.dWidth() , height: 80.dWidth())
            marker.iconView?.backgroundColor = UIColor.clear
            busLatestMarker = marker
            
            liveTrackViewModel.fetchBusRoutes(busName: "Jamuna", busTime: "6:30AM") { routes in
                routes.forEach { print($0.mapPlaceName) }
            }
        }
    }
}

struct LiveTrackView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTrackView()
    }
}
