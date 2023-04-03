//
//  ChatbotView.swift
//  InfocuspChat
//
//  Created by Aniket Rawat on 02/04/23.
//

import SwiftUI
import Resolver

struct ChatbotView: View {
    @Injected var fm: FirebaseManager
    @State var messages: [BotMessage] = []
//    @State var messages: [BotMessage] = [
//        BotMessage(author: .user, content: "hello there"),
//        BotMessage(author: .bot, content: "With iOS 16, iPhones can also take advantage of widgets. Widget module will have the widget placed in homescreen to view quick messages of selected chats. There will also be widget for i"),
//        BotMessage(author: .user, content: "give me a generic templete for leave application"),
//        BotMessage(author: .bot, content: "Dear [Manager's Name], \n I am writing to formally request a leave of absence from [Start Date] to [End Date] for [Reason for Leave].\nI have carefully considered the impact that my absence will have on the department and have taken steps to minimize any disruptions that may occur during my absence. I have discussed my workload with [colleague's name] and have made arrangements to ensure that all urgent tasks are completed prior to my departure. \nI understand that my absence may cause some inconvenience, and I apologize for any inconvenience that this may cause. I am committed to ensuring a smooth transition and will do everything in my power to ensure that my work is completed to the best of my ability before my departure. \nThank you for considering my request for leave. I look forward to returning to work on [Return Date] and will do my best to make up for any lost time upon my return. \nSincerely,\n[Your Name]")
//
//    ]
    @State var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            
                            if message.author == .user {
                                Spacer()
                            }
                            
                            Text(message.content)
                                .lineLimit(nil)
                                .foregroundColor(.white)
                                .padding(.vertical, 7)
                                .padding(.horizontal)
                                .background(message.author == .user ? Color.blue : Color.gray)
                                .cornerRadius(10)
                            
                            
                            if message.author == .bot {
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        
                        
                    }
                }
            }
            
            Spacer()
            
            HStack {
                TextField("Enter queries here", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    
                    messages.append(BotMessage(author: .user, content: text))
                    
                    let userInput = text
                    text = ""
                    Task {
                        let response  = await fm.chatbotManager.send(text: userInput)
                        messages.append(BotMessage(author: .bot, content: response))
                        text = ""
                    }
                    
                    
                }
                .buttonStyle(.borderedProminent)
            }
            
        }
        .padding()
        .onAppear {
            fm.chatbotManager.setup()
        }
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
