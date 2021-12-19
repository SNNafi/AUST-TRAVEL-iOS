//
//  NoNetView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 19/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct NoNetView: View {
    
    @EnvironmentObject var networkReachability: NetworkReachability
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .frame(width: 130.dWidth(), height: 130.dWidth(), alignment: .center)
                .foregroundColor(.redAsh)
            Text("No Internet Connection")
                .scaledFont(font: .sairaCondensedSemiBold, dsize: 24)
                .foregroundColor(.redAsh)
            Text("Please check your internet connection")
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .scaledFont(font: .sairaCondensedSemiBold, dsize: 17)
                .foregroundColor(.redAsh)
            
            ABButton(text: "Try again", textColor: .black, backgroundColor: .greenLight, font: .sairaCondensedRegular) {
                networkReachability.checkConnection()
            }
            .rightIcon(Icon(name: "arrow.clockwise").iconColor(.black).systemImage())
            .width(dWidth * 0.5)
            
        }
    }
}

struct NoNetView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetView()
    }
}
