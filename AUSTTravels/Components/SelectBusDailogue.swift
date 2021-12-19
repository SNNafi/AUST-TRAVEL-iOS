//
//  AlertDailogue.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 10/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct SelectBusDailogue: View {
    
    var isBusTimeDropDownShown: Bool = false
    @Binding var buses: [Bus]
    @Binding var selectedBusName: String
    @Binding var selectedBusTime: String
    @Binding var display: Bool
    var action: () -> () = { }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            ZStack {
                RoundedRectangle(cornerRadius: 20.dHeight())
                    .foregroundColor(.white)
                VStack {
                    GeometryReader { gReader in
                        VStack {
                            Rectangle()
                                .frame(width: gReader.size.width, height: 60.dHeight(), alignment: .center)
                                .foregroundColor(.yellowLight)
                                .cornerRadius(20.dWidth(), corners: [.topLeft, .topRight])
                                .overlay(Text("SELECT BUS").scaledFont(font: .sairaCondensedSemiBold, dsize: 18).foregroundColor(.black))
                            
                            DropDown(icon: "bus", placeholder: "Select bus name", itemList: buses.map(\.name), selectedItem: $selectedBusName)
                                .itemTextColor(.black)
                                .selectedBorderColor(.green)
                                .width(gReader.size.width * 0.75)
                                .expandedList(dheight: 100)
                            
                            if isBusTimeDropDownShown {
                                if let timings = buses.first(where: { bus in
                                    bus.name == selectedBusName
                                }).map(\.timing)?.map(\.startTime) {
                                    DropDown(icon: "bus", placeholder: "Select bus time", itemList: timings, selectedItem: $selectedBusTime)
                                        .itemTextColor(.black)
                                        .selectedBorderColor(.green)
                                        .width(gReader.size.width * 0.75)
                                        .expandedList(dheight: 70)
                                }
                                
                            }
                            Button {
                                action()
                                display.toggle()
                            } label: {
                                Text("SELECT")
                                    .scaledFont(font: .sairaCondensedRegular, dsize: 16)
                                    .foregroundColor(.white)
                                    .frame(width: gReader.size.width * 0.75, height: 50.dHeight(), alignment: .center)
                            }
                            
                            .background(Color.green)
                        }
                    }
                }
                
            }
            .frame(width: dWidth * 0.8, height: dHeight * (isBusTimeDropDownShown ? 0.38 : 0.29))
            
        }
        .frame(width: dWidth, height: dHeight, alignment: .center)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            display.toggle()
        }
    }
}

//struct SelectBusDailogue_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectBusDailogue()
//    }
//}
