//
//  ABFloatingButton.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 7/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct FloatingButton: View {
    
    var name: String
    var action: () -> ()
    var isSystemImage: Bool = false
    var iconColor: Color = .white
    var backgroundColor: Color = .orange

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.orange)
                if isSystemImage {
                    Image(systemName: name)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(iconColor)
                        .frame(width: 21.dWidth(), height: 21.dWidth(), alignment: .center)
                } else {
                    Image(name)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(iconColor)
                        .frame(width: 21.dWidth(), height: 21.dWidth(), alignment: .center)
                }
                
            }
            .background(backgroundColor)
            .clipShape(Circle())
            .frame(width: 47.dWidth(), height: 47.dWidth(), alignment: .center)
            .shadow(color: .black.opacity(0.3), radius: 3.dWidth())
        }
        
    }
}

//struct FloatingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingButton()
//    }
//}

extension FloatingButton {
    
    func systemImage(_ systemImage: Bool = true) -> FloatingButton {
        var view = self
        view.isSystemImage = systemImage
        return view
    }
    
    func iconColor(_ color: Color) -> FloatingButton {
        var view = self
        view.iconColor = color
        return view
    }
    
    func backgroundColor(_ color: Color) -> FloatingButton {
        var view = self
        view.backgroundColor = color
        return view
    }
}
