//
//  MapInfoView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct MapInfoView: View {
    var route: Route
    var body: some View {
        VStack(alignment: .leading) {
            Text(route.place)
                .scaledFont(font: .sairaCondensedBold, dsize: 8)
                .foregroundColor(.black)
            Text("Est. Time: \(route.estTime)")
                .scaledFont(font: .sairaCondensedLight, dsize: 7)
                .foregroundColor(.black)
            Text("Tap here to view directions")
                .scaledFont(font: .sairaCondensedSemiBold, dsize: 4)
                .foregroundColor(.redAsh)
        }
        .padding(2.dWidth())
        .background(Color.white)
        .frame(width: 200, height: 100, alignment: .center)
        .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 1, y: 1)
    }
}

struct MapInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MapInfoView(route: Route())
    }
}
