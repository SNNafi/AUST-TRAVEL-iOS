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
    var isSystemImage: Bool = false
    var itemTextColor: Color = .white
    var selectedBorderColor: Color = .black
    var errorTextColor: Color = .red
    var frameWidth = UIScreen.main.bounds.width * 0.85
    var expandedListHeight: CGFloat = 150
    @State private var isDropDownListShow: Bool = false
    var validator: String? = nil
    
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    isDropDownListShow.toggle()
                }
            } label: {
                
                VStack {
                    HStack {
                        
                        Icon(name: icon)
                            .iconColor(itemTextColor)
                            .systemImage(isSystemImage)
                        
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
                    .frame(width: frameWidth)
                    .padding(10.dHeight())
                    .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(isDropDownListShow ? selectedBorderColor : itemTextColor, lineWidth: 1.dWidth()))
                    .padding(.horizontal, 15.dWidth())
                    
                    if validator != nil {
                        
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .scaledFont(font: .sairaCondensedSemiBold, dsize: 14)
                                .foregroundColor(errorTextColor)
                            
                            Text(validator ?? "")
                                .fontWeight(.light)
                                .scaledFont(font: .sairaCondensedSemiBold, dsize: 14)
                                .foregroundColor(errorTextColor)
                            
                            Spacer()
                            
                        }
                        .padding(10.dHeight())
                        .padding(.horizontal, 15.dHeight())
                    }
                }
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
                                    .frame(width: frameWidth)
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
                .offset(y: -(expandedListHeight - 40).dHeight())
                .frame(height: expandedListHeight.dHeight())
                
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
    
    func systemImage() -> DropDown {
        var view = self
        view.isSystemImage = true
        return view
    }
    
    func errorTextColor(_ color: Color) -> DropDown {
        var view = self
        view.errorTextColor = color
        return view
    }
    
    func addValidator(_ message: String?) -> DropDown {
        var view = self
        view.validator = message
        return view
    }
    
    func width(_ width: CGFloat) -> DropDown {
        var view = self
        view.frameWidth = width
        return view
    }
    
    func expandedList(dheight: CGFloat) -> DropDown {
        var view = self
        view.expandedListHeight = dheight
        return view
    }
    
}
