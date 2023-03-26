//
//  FirebaseManager.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import Foundation
import FirebaseFirestore
import Combine

class FirebaseManager: ObservableObject {
    var firestoreManager = FirestoreManager()
    @Published var authManager = AuthManager()
    @Published var chatManager = ChatManager()
    
    var anyCancellableAuth: AnyCancellable? = nil
    var anyCancellableChat: AnyCancellable? = nil
    
    init(){
        authManager.firestoreManager = firestoreManager
        
        chatManager.authManager = authManager
        chatManager.firestoreManager = firestoreManager
        
        anyCancellableAuth = authManager
            .objectWillChange
            .sink { [weak self] (_) in
                self?.objectWillChange.send()
                
            }
        
        anyCancellableChat = chatManager
            .objectWillChange
            .sink { [weak self] (_) in
                self?.objectWillChange.send()
                
            }
    }
}
