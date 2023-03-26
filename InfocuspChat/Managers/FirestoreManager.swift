//
//  FirestoreManager.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    
    private var db = Firestore.firestore()
    
    init() {}
    
    func addNewUser(user: ICUser) {
        let collectionRef = db.collection("users")
        
        do {
            let _ = try collectionRef.addDocument(from: user)
        } catch {
            print(error)
        }
    }
    
    func getAllUsers() async -> [ICUser] {
        do {
            let collectionRef = db.collection("users")
            
            let querySnapshot = try await collectionRef.getDocuments()
            return try querySnapshot.documents.map { document in
                return try document.data(as: ICUser.self)
            }
            
        } catch {
            print(error)
        }
        
        return []
        
    }
    
    func getUserById(userId: String) async -> ICUser? {
        do {
            let collectionRef = db.collection("users")
            let documentRefrence = collectionRef.document(userId)
            let documentSnapshot = try await documentRefrence.getDocument()
            return try documentSnapshot.data(as: ICUser.self)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func getUserByIds(ids: [String]) async -> [ICUser] {
        do {
            let collectionRef = db.collection("users").whereField("id", in: ids)
            
            let querySnapshot = try await collectionRef.getDocuments()
            return try querySnapshot.documents.map { document in
                return try document.data(as: ICUser.self)
            }
            
        } catch {
            print(error)
        }
        
        return []
    }
    
    func isPersonalChatCreated(chat: Chat) -> DocumentReference? {
        
        return nil
    }
    
    func createPersonalChat(chat: Chat) -> DocumentReference? {
        let collectionRef = db.collection("chats")
        
        do {
            let docRef = try collectionRef.addDocument(from: chat)
            return docRef
        } catch {
            print(error)
        }
        return nil
    }
    
    func createGroupChat(chat: Chat) -> DocumentReference? {
        let collectionRef = db.collection("chats")
        
        do {
            let docRef = try collectionRef.addDocument(from: chat)
            return docRef
            
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchAllUserChats(userId: String) async -> [ICChat] {
        do {
            let collectionRef = db.collection("chats").whereField("participants", arrayContainsAny: [userId])
            
            let querySnapshot = try await collectionRef.getDocuments()
            let chats = try querySnapshot.documents.map { document in
                return try document.data(as: Chat.self)
            }
            
            var icChats:[ICChat] = []
            
            for chat in chats {
                let users = await getUserByIds(ids: chat.participants)
                icChats.append(ICChat(chat: chat, users: users))
            }
            
            return icChats
            
        } catch {
            print(error)
        }
        
        return []
    }
    
    func fetchChatById(chatId: String) async -> ICChat? {
        do {
            let collectionRef = db.collection("chats")
            let documentRefrence = collectionRef.document(chatId)
            let documentSnapshot = try await documentRefrence.getDocument()
            let chat = try documentSnapshot.data(as: Chat.self)
            let users = await getUserByIds(ids: chat.participants)
            
            return ICChat(chat: chat, users: users)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func sendMessage(message: Message) -> DocumentReference? {
        let collectionRef = db.collection("messages")
        
        do {
            let docRef = try collectionRef.addDocument(from: message)
            return docRef
        } catch {
            print(error)
        }
        return nil
    }
    
    func listenMessage(chatId: String, completion: @escaping ([Message])->()) {
        db.collection("messages").whereField("chatId", isEqualTo: chatId).order(by: "time")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                let messages = documents.map { queryDocumentSnapshot in
                    try! queryDocumentSnapshot.data(as: Message.self)
                }
                
                completion(messages)
            }
    }
    
}
