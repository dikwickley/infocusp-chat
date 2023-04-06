//
//  ChatView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 14/02/23.
//

import SwiftUI
import Resolver
import WidgetKit

struct ChatSelectView: View {
    @Injected var fm: FirebaseManager
    @State var chats: [ICChat] = []
    @State var updater: Bool = false
    @State var chatSheet = false
    @State var selectedChatId: String?
    @AppStorage("pinned", store: UserDefaults(suiteName: "group.com.infocusp.widget.shared")) var pinned: String = "None"
    
    @State var timer: Timer?
    
    var body: some View {
        
        
        VStack {
            List(chats, id: \.id) { chat in
                
                ChatRow(chat: chat)
                    .onTapGesture {
                        chatSheet.toggle()
                        selectedChatId = chat.id
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions(allowsFullSwipe: false) {
                        
                        Button {
                            pinned = chat.id
                            WidgetCenter.shared.reloadAllTimelines()
                        } label: {
                            if chat.id == pinned {
                                Image(systemName: "pin.fill")
                            } else {
                                Image(systemName: "pin")
                            }
                        }
                        .tint(.indigo)
                        
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .tint(.red)

                    }
                    
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
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                print("hello \(UUID().uuidString)")
                Task {
                    await fetchChats()
                }
            }
        }
        .onDisappear {
            if let timer {
                timer.invalidate()
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
                if chat.chat.chatType == .personal {
                    
                    
                    ForEach(chat.users) { user in
                        if user.id != fm.authManager.auth.currentUser?.uid {
                            AvatarView(seed: user.id ?? "none", size: CGSize(width: 50, height: 50))
                            VStack(alignment: .leading) {
                                Text(user.name ?? "None")
                                
                                if let lastMessage = chat.lastMessage{
                                    Text("\(lastMessage.content)")
                                        .font(.caption)
                                } else {
                                    Text(" ")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct ChatSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSelectView()
    }
}
