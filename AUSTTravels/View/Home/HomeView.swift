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
                        
                        ABButton(text: "SHARE LOCATION", textColor: .white, backgroundColor: .redAsh, font: .sairaCondensedRegular) {
                            
                        }
                        .rightIcon(Icon(name: "map-location").iconColor(.black))
                        
                        ABButton(text: "VIEW VOLUNTEERS", textColor: .black, backgroundColor: .greenLight, font: .sairaCondensedRegular) {
                            
                        }
                        .rightIcon(Icon(name: "group").iconColor(.black))
                        Spacer()
                        
                        HStack {
                            Spacer()
//                            if let url = austTravel.currentUserPhotoUrl {

                                ABURLImage(imageURL: URL(string: "https://avatars.dicebear.com/api/bottts/Shahriar%20Nasim%20Nafi.png")!)
                                    .padding(.horizontal, 3.dWidth())
                           // }
                            
                            Text(austTravel.currentUserEmail ?? "")
                                .foregroundColor(.black)
                                .scaledFont(font: .sairaCondensedBold, dsize: 17)
                                .padding(.trailing, 3.dWidth())
                            Spacer()
                        }
                        .frame(height: 85.dHeight(), alignment: .center)
                        .background(Color.gray.opacity(0.5))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                }
            }
            .onAppear {
                homeViewModel.getVolunteerInfo { volunteer, error in
                    
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
