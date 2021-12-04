//
//  ContentView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    
    var body: some View {

//        if austTravel.currentAuthPage == .none {
//            HomeView()
//        } else {
//            AuthView()
//        }
        SignInView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
