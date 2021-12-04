//
//  ABTextField.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ABTextField: View {
    
    var placeholder: String
    @Binding var text: String
    var icon: Icon? = nil
    var textColor: Color = .white
    var borderColor: Color = .gray
    var errorTextColor: Color = .red
    var validator: String? = nil
    var isSecureField: Bool = false
    var keyboardType: UIKeyboardType = .default
    @State private var isPasswordHIdden = false
    
    var body: some View {
        VStack {
            HStack {
                if icon != nil {
                    icon
                }
                 
                if isPasswordHIdden && isSecureField {
                    SecureField("", text: $text)
                        .keyboardType(keyboardType)
                        .placeholder(when: $text.wrappedValue.isEmpty) {
                            Text(placeholder)
                        }
                        .frame(height: 47.dHeight())
                        .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                        .foregroundColor(textColor)
                } else {
                    TextField("", text: $text)
                        .keyboardType(keyboardType)
                        .placeholder(when: $text.wrappedValue.isEmpty) {
                            Text(placeholder)
                        }
                        .frame(height: 47.dHeight())
                        .scaledFont(font: .sairaCondensedRegular, dsize: 17)
                        .foregroundColor(textColor)
                }
                
                if isSecureField {
                    Button {
                        isPasswordHIdden.toggle()
                    } label: {
                        
                        Image(systemName: isPasswordHIdden ? "eye.fill" : "eye.slash.fill")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.greenLight)
                            .scaledToFit()
                            .frame(height: 12.dWidth(), alignment: .center)
                    }
                }
                
            }
            .frame(width: dWidth * 0.85)
            .padding(10.dHeight())
            .overlay(RoundedRectangle(cornerRadius: 7.dWidth()).stroke(borderColor, lineWidth: 1.dWidth()))
            .padding(.horizontal, 15.dHeight())
            
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
}

//
//struct ABTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        ABTextField()
//    }
//}


extension ABTextField {
    
    func rightIcon(_ icon: Icon) -> ABTextField {
        var view = self
        view.icon = icon
        return view
    }
    
    func textColor(_ color: Color) -> ABTextField {
        var view = self
        view.textColor = color
        return view
    }
    
    func borderColor(_ color: Color) -> ABTextField {
        var view = self
        view.borderColor = color
        return view
    }
    
    func errorTextColor(_ color: Color) -> ABTextField {
        var view = self
        view.errorTextColor = color
        return view
    }
    
    func addValidator(_ message: String?) -> ABTextField {
        var view = self
        view.validator = message
        return view
    }
    
    func secureField(_ secure: Bool) -> ABTextField {
        var view = self
        view.isSecureField = secure
        return view
    }
    
    func keyboardType(_ type: UIKeyboardType) -> ABTextField {
        var view = self
        view.keyboardType = type
        return view
    }
    
}
