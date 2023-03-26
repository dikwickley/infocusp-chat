//
//  ChatManager.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 17/02/23.
//

import Foundation

class ChatManager: ObservableObject {
    
    var firestoreManager: FirestoreManager?
    var authManager: AuthManager?
    
    var chatId: String?
    @Published var currentChat: ICChat?
    var messages: [Message]?
    
    func start() async {
        guard let chatId else { return }
        guard let firestoreManager else { return }
        guard let authManager else { return }
        
        self.currentChat = await firestoreManager.fetchChatById(chatId: chatId)
    }
    
}
