//
//  LoginView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 27/01/23.
//

import SwiftUI
import Resolver

struct LoginView: View {
    @Binding var authScreen: AuthScreen
    
    @State var email: String = "aniket@infocusp.com"
    @State var password: String = "123456"
    
    @Injected var fm: FirebaseManager
    
    
    var body: some View {
        NavigationView {
            
            VStack() {
                Spacer()
                TextField("", text: $email)
                    .placeholder(when: email.isEmpty){
                        Text("Enter email")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accentColor(.white)
                
                SecureField("", text: $password)
                    .placeholder(when: password.isEmpty){
                        Text("Enter password")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accentColor(.white)
                
                HStack {
                    Text("Don't have an account?")
                    Button {
                        authScreen = .signup
                    } label: {
                        Text("Create")
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await login()
                        }
                        
                    } label: {
                        Text("Login")
                            .bold()
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                    }
                }
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Image("infocusp-logo-color")
                    }
                }
            }
            .navigationTitle("Login")
            .padding()
        }
    }
    
    func login() async {
        let (response, error) = await fm.authManager.asyncLogin(email: email, password: password)
        
        if let response = response {
            print(response.user.email ?? "no email")
            print(response.user.displayName ?? "no display name")
        }
        
        if let error = error {
            //create error toast
            print(error.localizedDescription)
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authScreen: .constant(AuthScreen.signup))
    }
}
