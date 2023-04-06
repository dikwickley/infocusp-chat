//
//  ChatView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 17/02/23.
//

import SwiftUI
import Resolver

import Combine
import UIKit


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

struct ChatView: View, KeyboardReadable {
    var chatId: String
    @State var currentChat: ICChat?
    @State var messageContent: String = ""
    @State var messages: [Message] = []
    @Injected var fm: FirebaseManager
    

    init(chatId: String) {
        self.chatId = chatId
        fm.chatManager.chatId = chatId
    }
    
    var body: some View {
        VStack {
            if let currentChat = currentChat {
                
                HStack {
                    
                    if currentChat.chat.chatType == .personal {
                        ForEach(currentChat.users) { user in
                            if user.id != fm.authManager.auth.currentUser?.uid {
                                
                                AvatarView(seed: user.id ?? "none", size: CGSize(width: 50, height: 50))
                                
                                Text(user.name ?? "None")
                                    .font(.title2)
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
//                Text("\(currentChat.chat.id ?? "None")")
//                    .font(.caption2)
                
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { value in
                        ForEach(messages, id: \.id) { message in
                            MessageRow(
                                message: message, sender: message.senderId == fm.authManager.auth.currentUser?.uid
                            )
                            
                            
                        }
                        .onChange(of: messages, perform: { newValue in
                            value.scrollTo(messages.last?.id, anchor: .bottom)
                        })
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            value.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                        
                    }
                }
                
            }
            
            
            Spacer()
            
            HStack {
                TextField("Enter message", text: $messageContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    sendMessage()
                    messageContent = ""
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onAppear {
            Task {
                await fm.chatManager.start()
                currentChat = fm.chatManager.currentChat
                fm.firestoreManager.listenMessage(chatId: chatId) { messages = $0 }
            }
        }
        
        
    }
    
    func sendMessage(){
        let newMessage = Message(
            senderId: fm.authManager.auth.currentUser?.uid ?? "none",
            chatId: currentChat?.id ?? "none",
            time: Date(),
            content: messageContent
        )
        
        let _ = fm.firestoreManager.sendMessage(message: newMessage)
    }
}

struct MessageRow: View {
    var message: Message
    var sender: Bool
    
    var bubbleColor: Color {
        if sender {
            return .blue
        } else {
            return .gray
        }
    }
    
    var bubblePosition: HorizontalAlignment {
        if sender {
            return .trailing
        } else {
            return .leading
        }
    }

    
    var body: some View {
        
        
        HStack {
            if sender {
                Spacer()
            }
            Text(message.content)
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 7)
                .padding(.horizontal)
                .background(bubbleColor)
                .cornerRadius(10)
            
            if !sender {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatId: "gk4UFUitCvdH2nzA7GR2")
    }
}
