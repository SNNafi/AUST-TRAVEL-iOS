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
            
            Text(route.mapPlaceName)
                .lineLimit(nil)
                .scaledFont(font: .sairaCondensedBold, dsize: 20)
                .foregroundColor(.black)
            // .fixedSize()
            Text("Est. Time: \(route.estTime)")
                .scaledFont(font: .sairaCondensedLight, dsize: 15)
                .foregroundColor(.black)
            Text("Tap here to view directions")
                .scaledFont(font: .sairaCondensedSemiBold, dsize: 14)
                .foregroundColor(.redAsh)
            
        }
        .padding(2.dWidth())
        .background(Color.white)
        .offset(x: 0, y: 20)
    }
}

struct MapInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MapInfoView(route: Route())
    }
}
