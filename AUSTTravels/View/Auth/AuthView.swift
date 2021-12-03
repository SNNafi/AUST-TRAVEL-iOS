//
//  AuthView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    
    var body: some View {
        if austTravel.currentAuthPage == .signIn {
            SignInView()
                .transition(.move(edge: .trailing))
        } else  if austTravel.currentAuthPage == .signUp {
            SignUpView()
                .transition(.move(edge: .trailing))
        } else  if austTravel.currentAuthPage == .forgetPassword {
            ForgotPasswordView()
                .transition(.move(edge: .trailing))
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
