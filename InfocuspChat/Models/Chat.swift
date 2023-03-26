//
//  Chat.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 10/02/23.
//

import Foundation
import FirebaseFirestoreSwift
import Resolver

enum ChatType: String, Codable {
    case personal
    case group
}

struct Chat: Codable, Identifiable { // model for firebase
    @DocumentID var id: String?
    var chatType: ChatType?
    var participants: [String] //ids of ICUser
}

struct ICChat: Codable, Identifiable {
    var chat: Chat
    var users: [ICUser]
    var id: String {
        chat.id ?? "none"
    }
    
}
