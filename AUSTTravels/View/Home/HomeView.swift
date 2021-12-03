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
    
    var body: some View {
        
        VStack {
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
                        Text("H O M E")
                            .scaledFont(font: .sairaCondensedBold, dsize: 26)
                        Text(austTravel.currentFirebaseUser?.displayName ?? "")
                            .scaledFont(font: .sairaCondensedSemiBold, dsize: 19)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
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
