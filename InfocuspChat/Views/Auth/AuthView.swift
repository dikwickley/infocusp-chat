//
//  AuthView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import SwiftUI

enum AuthScreen {
    case login
    case signup
}

struct AuthView: View {
    @State var authScreen: AuthScreen = .login
    
    var body: some View {

        switch authScreen {
        case .login : LoginView(authScreen: $authScreen)
        case .signup: SignupView(authScreen: $authScreen)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
