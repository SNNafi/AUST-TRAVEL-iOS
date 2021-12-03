//
//  ABButton.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 1/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ABButton: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    var font: GenericFont.Font
    var action: () -> ()
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 7.dWidth()).foregroundColor(backgroundColor)
                .frame(width: dWidth * 0.9, height: 57.dHeight())
                .padding( 10.dHeight())
                .overlay(Text(text)
                            .scaledFont(font: font, dsize: 18)
                            .foregroundColor(textColor))
                .padding(.horizontal, 15.dHeight())
        }
        
    }
}

struct ABButton_Previews: PreviewProvider {
    static var previews: some View {
        ABButton(text: "", textColor: .white, backgroundColor: .black, font: .sairaCondensedRegular, action: {})
    }
}
