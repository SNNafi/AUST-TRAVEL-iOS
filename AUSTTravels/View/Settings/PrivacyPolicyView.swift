//
//  PrivacyPolicyView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 13/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct PrivacyPolicyView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    Icon(name: "back")
                        .iconColor(.white)
                        .clickable {
                            withAnimation {
                                austTravel.currentPage = .settings
                            }
                        }
                        .padding(.horizontal, 15.dWidth())
                        .padding(.trailing, 3.dWidth())
                    
                    Text("Privacy & Policy")
                        .scaledFont(font: .sairaCondensedBold, dsize: 20)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15.dWidth())
                    Spacer()
                    

                }
                Spacer()
            }
            .frame(width: dWidth, height: dHeight * 0.12)
            .background(Color.green)
            Webview(url: URL(string: "https://docs.google.com/document/d/e/2PACX-1vS5wewwH80RD_aSnROlwgscRDkVB8kJSArf23JHzGqmHKL9V1fR1AnFEQ1IzIdC1ectabtbwChxxE8l/pub?embedded=true")!) {
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
