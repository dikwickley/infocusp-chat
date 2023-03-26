//
//  Message.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 10/02/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserTimeStamp: Codable {
    var userUID: String
    var time: Date
}

struct Message: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var senderId: String
    var chatId: String
    var time: Date
    var content: String
}

struct ICMessage: Codable, Identifiable {
    var message: Message
    var sender: ICUser
    var id: String {
        message.id ?? "none"
    }
}
