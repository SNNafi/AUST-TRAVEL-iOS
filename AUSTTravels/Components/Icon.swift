//
//  Icon.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct Icon: View {
    
    var name: String
    var isSystemImage: Bool = false
    var color: Color = .white
    var clickable: Bool = false
    var action: () -> () = { }
    var body: some View {
        
        if clickable {
            Button {
                action()
            } label: {
                view
            }

        } else {
            view
        }
    }
    
    @ViewBuilder
    var view: some View {
        if isSystemImage {
            Image(systemName: name)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(color)
                .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
        } else {
            Image(name)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(color)
                .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
        }

    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(name: "user")
    }
}

extension Icon {
    func systemImage() -> Icon {
        var view = self
        view.isSystemImage = true
        return view
    }
    
    func iconColor(_ color: Color) -> Icon {
        var view = self
        view.color = color
        return view
    }
    
    func clickable(_ action: @escaping () -> ()) -> Icon {
        var view = self
        view.clickable = true
        view.action = action
        return view
    }
}
