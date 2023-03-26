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
    
    var body: some View {
        NavigationView {
            
            VStack{
                List(users, selection: $selectedUsers) { user in
                    VStack(alignment: .leading) {
                        Text(user.name!)
                        Text(user.id!)
                            .font(.caption2)
                    }
                    .listRowBackground(Color.clear)
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
            fm.firestoreManager.createPersonalChat(chat: newChat)
        }
        
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
