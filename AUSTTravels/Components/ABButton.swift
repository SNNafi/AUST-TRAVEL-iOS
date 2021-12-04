//
//  ABButton.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 1/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Combine

struct ABButton: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    var font: GenericFont.Font
    var action: () -> ()
    var icon: Icon? = nil
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 7.dWidth()).foregroundColor(backgroundColor)
                    .frame(width: dWidth * 0.9, height: 57.dHeight())
                    .padding(10.dHeight())
                    .padding(.horizontal, 15.dHeight())
                HStack {
                    if icon != nil {
                        icon
                    }
                    Text(text)
                        .scaledFont(font: font, dsize: 18)
                        .foregroundColor(textColor)
                }
            }
        }
    }
}

struct ABButton_Previews: PreviewProvider {
    static var previews: some View {
        ABButton(text: "", textColor: .white, backgroundColor: .black, font: .sairaCondensedRegular, action: {})
    }
}

extension ABButton {
    func rightIcon(_ icon: Icon) -> ABButton {
        var view = self
        view.icon = icon
        return view
    }
}
