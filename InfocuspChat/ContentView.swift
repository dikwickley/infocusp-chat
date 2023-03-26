//
//  ContentView.swift
//  InfocuspChat
//
//  Created by Mehul Thakkar on 25/01/23.
//

import SwiftUI






struct ContentView: View {
    @State var showChat = true
    
    var body: some View {
        VStack{
            Text("Hello World")
            
            Button("Open Chat") {
                showChat.toggle()
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $showChat) {
            MainChat()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
