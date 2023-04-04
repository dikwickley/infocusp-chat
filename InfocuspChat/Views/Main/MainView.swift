//
//  MainView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import SwiftUI
import Resolver

enum Screen {
    case bot
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
    @State var showChatSheet = false
    
    init() {
        print("MainView init")
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                    
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    
                    
                    
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
                        currentScreen = .bot
                    } label: {
                        Image(systemName:
                                currentScreen == .bot ? "cpu.fill" : "cpu"
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
                
            }
            .frame(maxWidth: .infinity)
            .font(.title)
            .padding(.vertical)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color(0x438BFB))
            
            
            
            VStack {
                switch currentScreen {
                case .bot: ChatbotView()
                case .chats: ChatSelectView()
                case .users: UserView()
                case .settings: Settings()
                }
            }
            
            Spacer()
            
        }
    }
    
}



struct Settings: View{
    @Injected var fm: FirebaseManager
    var body: some View {
        VStack {
            Text("Settings")
            AvatarView(seed: fm.authManager.auth.currentUser?.uid ?? "none")
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
