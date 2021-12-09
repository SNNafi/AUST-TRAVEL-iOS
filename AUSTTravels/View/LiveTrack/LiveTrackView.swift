//
//  LiveTrackView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import GoogleMaps.GMSMarker
import SPAlert

struct LiveTrackView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var liveTrackViewModel = UIApplication.shared.liveTrackViewModel
    
    @State private var currentLocation: CLLocation?
    @State private var selectedCoordinater: CLLocationCoordinate2D?
    @State private var busLatestMarker: GMSMarker?
    @State private var busRoutes = [GMSMarker]()
    @State private var mapBinding: MapBinding = .multiple
    @State private var mapError: Bool = false
    var selectedBus: String = "Jamuna"
    var selectedBusTime: String = "6:30AM"
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    GoogleMapView(selectedCoordinater: $selectedCoordinater, busLatestMarker: $busLatestMarker, markers:
                                    $busRoutes, currentLocation: $currentLocation, mapBinding: $mapBinding) { marker in
                        if (marker.userData as? Route) != nil {
                            return false
                        }
                        return true
                        
                    } didTapInfoWindowOf: { marker in
                        if let route = marker.userData as? Route {
                            if let busLatestCoordinate = busLatestMarker?.position {
                                if !liveTrackViewModel.openDirectionOnGoogleMap(busLatestCoordinate: busLatestCoordinate, route: route) {
                                    mapError = true
                                    HapticFeedback.error.provide()
                                }
                            }
                            
                        }
                    }
                    .frame(width: dWidth, height: dHeight * 0.68, alignment: .center)
                    .offset(y: -12.dHeight())
                    
                    VStack {
                        HStack {
                            Spacer()
                            ABFloatingButton(name: "bus") {
                                if let busLatestMarker = busLatestMarker {
                                    let coordinator = CLLocationCoordinate2D(latitude: busLatestMarker.position.latitude, longitude: busLatestMarker.position.longitude)
                                    selectedCoordinater = coordinator
                                    if mapBinding == .selectedMarker {
                                        mapBinding = .selectedMarker2
                                    } else if mapBinding == .selectedMarker2 {
                                        mapBinding = .selectedMarker
                                    } else {
                                        mapBinding = .selectedMarker
                                    }
                                }
                            }
                            .padding(10.dWidth())
                            .offset(x: 0, y: (dHeight * 0.25))
                        }
                    }
                }
                Spacer()
                Spacer()
            }
            .frame(width: dWidth, height: dHeight, alignment: .center)
            
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
                            .padding(.horizontal, 15.dWidth())
                            .padding(.trailing, 3.dWidth())
                        
                        Text("LIVE TRACKING")
                            .scaledFont(font: .sairaCondensedBold, dsize: 20)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15.dWidth())
                        Spacer()
                        
                        Icon(name: "gearshape.fill")
                            .systemImage()
                            .iconColor(.white)
                            .clickable {
                            }
                            .padding(.horizontal, 15.dWidth())
                    }
                    Spacer()
                }
                .frame(width: dWidth, height: dHeight * 0.12)
                .background(Color.green)
                
                Spacer()
                VStack {
                    Rectangle()
                        .frame(width: dWidth * 0.3, height: 2.dWidth())
                        .foregroundColor(.white)
                        .padding(.top, 8.dHeight())
                    
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
                    .frame(width: dWidth, height: dHeight * 0.13)
                    
                    Spacer()
                    
                }
                .frame(width: dWidth, height: dHeight * 0.26)
                .background(Color.green)
                .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
            }
        }
        
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            busLatestMarker = liveTrackViewModel.initialBusMarker()
            
            liveTrackViewModel.fetchBusRoutes(busName: "Jamuna", busTime: "6:30AM") { routes in
                routes.forEach { print($0.coordinate) }
                busRoutes = liveTrackViewModel.createRouteMarkers(routes)
            }
            
            liveTrackViewModel.observeBusLatestLocation(busName: "Jamuna", busTime: "6:30AM") { marker in
                busLatestMarker?.map = nil
                busLatestMarker = marker
                mapBinding = .centerToBus
            }
        }
        .onDisappear {
            liveTrackViewModel.removeObserver(busName: "Jamuna", busTime: "6:30AM")
        }
        .spAlert(isPresent: $mapError,
                 title: "Cannot open map !",
                 message: "Couldn't open the map. Do you have the latest version of Google Maps installed ?",
                 duration: 2,
                 dismissOnTap: true,
                 preset: .custom(UIImage(systemName: "exclamationmark.triangle.fill")!),
                 haptic: .none,
                 layout: .init(),
                 completion: {
            
        })
    }
}

struct LiveTrackView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTrackView()
    }
}
