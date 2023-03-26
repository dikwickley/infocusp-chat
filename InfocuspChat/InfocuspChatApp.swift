//
//  InfocuspChatApp.swift
//  InfocuspChat
//
//  Created by Mehul Thakkar on 25/01/23.
//

import SwiftUI
import FirebaseCore

@main
struct InfocuspChatApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
