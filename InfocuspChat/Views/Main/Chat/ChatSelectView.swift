//
//  ChatView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 14/02/23.
//

import SwiftUI
import Resolver

struct ChatSelectView: View {
    @Injected var fm: FirebaseManager
    @State var chats: [ICChat] = []
    @State var chatSheet = false
    @State var selectedChatId: String?
    
    var body: some View {
        
        
        VStack {
            List(chats, id: \.id) { chat in
                
                ChatRow(chat: chat)
                    .onTapGesture {
                        chatSheet.toggle()
                        selectedChatId = chat.id
                    }
                    .listRowBackground(Color.clear)
                    
            }
            .listStyle(.plain)
            .background(.white)
        }
        .sheet(isPresented: $chatSheet) {
            if let selectedChatId = selectedChatId {
                ChatView(chatId: selectedChatId)
            } else {
                Text("None")
            }
        }
        .onAppear {
            Task {
                await fetchChats()
            }
        }
        
    }
    
    func fetchChats() async {
        chats = await fm.firestoreManager.fetchAllUserChats(userId: fm.authManager.auth.currentUser?.uid ?? "none")
    }
}

struct ChatRow: View {
    @Injected var fm: FirebaseManager
    
    var chat: ICChat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(chat.users) { user in
                    if user.id != fm.authManager.auth.currentUser?.uid {
                        Text(user.name ?? "None")
                    }
                }
            }
            Text("\(chat.id)")
                .font(.caption2)
        }
    }
}

struct ChatSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSelectView()
    }
}
