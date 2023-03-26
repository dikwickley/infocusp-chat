//
//  CUser.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ICUser: Codable, Identifiable, Hashable {
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
}

