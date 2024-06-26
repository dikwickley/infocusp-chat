//
//  Users.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 10/02/23.
//

import SwiftUI
import Resolver

struct UserView: View{
    @Injected var fm: FirebaseManager
    @State var users: [ICUser] = []
    @State private var selectedUsers = Set<String?>()
    @State var selectedChatId: String?
    @State var chatSheet = false
    
    var body: some View {
        NavigationView {
            
            VStack{
                List(users, selection: $selectedUsers) { user in
                    if fm.authManager.auth.currentUser?.uid != user.id {
                        HStack {
                            AvatarView(seed: user.id ?? "none", size: CGSize(width: 50, height: 50))
                            
                            Text(user.name!)
//                            Text(user.id!)
//                                .font(.caption2)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .background(.white)
                
                Spacer()
                
                
                Button {
                    Task {
                        await startChat(selectedUsers: selectedUsers)
                    }
                } label: {
                    Text(
                        selectedUsers.count > 1 ?
                        "Start Group Chat" :
                        "Start New Chat"
                    )
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .environment(\.editMode, .constant(EditMode.active))
            .onAppear {
                Task {
                    await fetchUsers()
                }
            }
            .sheet(isPresented: $chatSheet) {
                if let selectedChatId = selectedChatId {
                    ChatView(chatId: selectedChatId)
                } else {
                    Text("None")
                }
            }
        }
    }
    
    func fetchUsers() async {
        users = await fm.firestoreManager.getAllUsers()
    }
    
    func startChat(selectedUsers: Set<String?>) async  {
        
        guard selectedUsers.count > 0 else { return }
        
        var users = selectedUsers
        users.insert(fm.authManager.auth.currentUser?.uid ?? "None")
        
        if selectedUsers.count > 1 { // group chat
//            let newChat = Chat(participants: Array(users), chatType: .group)
//            fm.firestoreManager.createGroupChat(chat: newChat)
        } else { // personal chat
            let newChat = Chat(chatType: .personal, participants: users.map { $0! })
            let docRef = await fm.firestoreManager.createPersonalChat(chat: newChat)
            selectedChatId = docRef?.documentID
            chatSheet.toggle()
        }
        
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
