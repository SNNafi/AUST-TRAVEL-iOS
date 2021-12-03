//
//  DropDown.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 3/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct DropDown: View {
    
    let icon: String
    let placeholder: String
    let itemList: [String]
    @Binding var selectedItem: String
    var itemTextColor: Color = .white
    var selectedBorderColor: Color = .black
    @State private var isDropDownListShow: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    isDropDownListShow.toggle()
                }
            } label: {
                HStack {
                    Image("user")
                        .resizable()
                        .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
                    Text(selectedItem.isEmpty ? placeholder : selectedItem)
                        .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                        .frame(height: 47.dHeight())
                        .foregroundColor(itemTextColor)
                    Spacer()
                    Image("downward-arrow")
                        .resizable()
                        .foregroundColor(isDropDownListShow ? selectedBorderColor : itemTextColor)
                        .frame(width: 9.dWidth(), height: 9.dWidth(), alignment: .center)
                        .rotationEffect(isDropDownListShow ? .degrees(-180) : .degrees(0))
                        .transition(.scale)
                    
                    
                }
                .frame(width: dWidth * 0.85)
                .padding(10.dHeight())
                .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(isDropDownListShow ? selectedBorderColor : itemTextColor, lineWidth: 1.dWidth()))
                .padding(.horizontal, 15.dWidth())
            }
            
            if isDropDownListShow {
                ScrollView {
                    VStack {
                        ForEach(itemList, id: \.self) { item in
                            Button {
                                withAnimation {
                                    selectedItem = item
                                    isDropDownListShow.toggle()
                                }
                                
                            } label: {
                                Text(item)
                                    .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                                    .foregroundColor(itemTextColor)
                                    .padding(.vertical, 3.dHeight())
                                    .frame(width: dWidth * 0.85)
                                    .background(Color.white)
                            }
                            
                        }
                    }
                    .background(Color.white)
                }
                .transition(.scale)
                .padding(3.dHeight())
                .background(Color.white)
                .shadow(color: .gray.opacity(0.4), radius: 5)
                .offset(y: -110.dHeight())
                .frame(height: 150.dHeight())
                
            }
        }
    }
}

struct DropDown_Previews: PreviewProvider {
    static var previews: some View {
        DropDown(icon: "user", placeholder: "Select your department", itemList: ["CSE", "EEE", "CE", "TE", "MPE", "ARCH", "BBA"], selectedItem: .constant(""))
            .itemTextColor(.black)
            .selectedBorderColor(.blue)
    }
}


extension DropDown {
    
    func itemTextColor(_ color: Color) -> DropDown {
        var view = self
        view.itemTextColor = color
        return view
    }
    
    func selectedBorderColor(_ color: Color) -> DropDown {
        var view = self
        view.selectedBorderColor = color
        return view
    }
    
}
