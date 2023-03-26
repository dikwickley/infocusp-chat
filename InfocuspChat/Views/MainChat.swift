//
//  ChatView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import SwiftUI
import Resolver

struct MainChat: View {
    @InjectedObject var fm: FirebaseManager
    
    var body: some View {
        Group {
            if fm.authManager.isAuth {
                MainView()
            } else {
                AuthView()
            }
        }
        .interactiveDismissDisabled(true)
    }
}

struct MainChat_Previews: PreviewProvider {
    static var previews: some View {
        MainChat()
    }
}
