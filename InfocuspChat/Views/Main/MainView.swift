//
//  MainView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import SwiftUI
import Resolver

enum Screen {
    case chats
    case users
    case settings
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct MainView: View {
    @Injected var fm: FirebaseManager
    @State var currentScreen: Screen = .chats
    @Environment(\.dismiss) var dismiss
    
    init() {
        print("MainView init")
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack(spacing: geometry.size.width/10) {
                    
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                        
                    }
                    
                    Button{
                        currentScreen = .chats
                    } label: {
                        Image(systemName:
                                currentScreen == .chats ? "message.fill" : "message"
                        )
                    }
                    
                    
                    Button{
                        currentScreen = .users
                    } label: {
                        Image(systemName:
                                currentScreen == .users ? "person.3.fill" : "person.3"
                        )
                        
                    }
                    
                    Button{
                        currentScreen = .settings
                    } label: {
                        Image(systemName:
                                currentScreen == .settings ? "gearshape.fill" : "gearshape"
                        )
                        
                    }
                    
                    
                }
                .frame(width: geometry.size.width)
                .font(.title)
                .padding(.vertical)
                .foregroundColor(.white)
                .background(Color(0x438BFB))
                
                
                
                VStack {
                    switch currentScreen {
                    case .chats: ChatSelectView()
                    case .users: UserView()
                    case .settings: Settings()
                    }
                }
                
                Spacer()
                
            }
        }
    }
}



struct Settings: View{
    @Injected var fm: FirebaseManager
    var body: some View {
        VStack {
            Text("Settings")
            Text("Hello \(fm.authManager.auth.currentUser?.displayName ?? "None" )")
            Button("Logout") {
                fm.authManager.logout()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
