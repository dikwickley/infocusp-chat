//
//  ChatbotManager.swift
//  InfocuspChat
//
//  Created by Aniket Rawat on 02/04/23.
//

import Foundation
import OpenAISwift


struct BotMessage: Hashable {
    enum Author: String {
        case user
        case bot
    }
    var author: Author
    var content: String
    var date: Date = Date()
}

class ChatbotManager: ObservableObject {
    var firestoreManager: FirestoreManager?
    var authManager: AuthManager?
    private var openAI: OpenAISwift?
    
    
    
    
    func setup(){
        openAI = OpenAISwift(authToken: "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")
    }
    
    func send(text: String) async -> String {
        guard let openAI else {
            print("error occured")
            return "error occured"
        }
        
        
        do {
            let result = try await openAI.sendChat(
                with: [
                    ChatMessage(role: .system, content: "You are a assistant that only provides email template. You only give email templates for a given promt. You respond with a 'Sorry, can not create an email template for that. Try again.' for any other type of promt. DO NOT ANSWER ANYTHING ELSE OTHER THAN EMAIL TEMPLATES."),
                    ChatMessage(role: .user, content: text)
                    
                ],
                model: .chat(.chatgpt),
                maxTokens: 300
            )
            return result.choices.first?.message.content ?? "None"
        } catch {
            return "error occured \(error.localizedDescription)"
        }
    }
    
}
