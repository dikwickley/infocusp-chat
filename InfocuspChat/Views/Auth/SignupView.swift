//
//  SignupView.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 07/02/23.
//

import SwiftUI
import Resolver

struct SignupView: View {
    @Binding var authScreen: AuthScreen
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordAgain: String = ""
    
    @Injected var fm: FirebaseManager
    
    var body: some View {
        NavigationView {
            
            VStack() {
                Spacer()
                
                TextField("", text: $name)
                    .placeholder(when: name.isEmpty){
                        Text("Enter name")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accentColor(.white)
                
                
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
                
                SecureField("", text: $passwordAgain)
                    .placeholder(when: passwordAgain.isEmpty){
                        Text("Enter password again")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accentColor(.white)
                
                HStack {
                    Text("Already have an account?")
                    Button {
                        authScreen = .login
                    } label: {
                        Text("Login")
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await signup()
                        }
                    } label: {
                        Text("Signup")
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
            .navigationTitle("Signup")
            .padding()
        }
    }
    
    func signup() async {
        guard password == passwordAgain else {
            //            toastManager.showToast(toastStyle: .error(description: "Passwords do not match"))
            return
        }
        guard name != "" else {
            //            toastManager.showToast(toastStyle: .error(description: "Name can not be empty"))
            return
        }
        let (response, error) = await fm.authManager.asyncSignup(email: email, password: password, displayName: name)
        
        if let response = response {
            print(response.user.email ?? "no email")
            print(response.user.displayName ?? "no display name")
            //            toastManager.showToast(toastStyle: .success(description: "Account Created"))
        }
        
        if let error = error {
            //            toastManager.showToast(toastStyle: .error(description: error.localizedDescription))
            print(error.localizedDescription)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(authScreen: .constant(AuthScreen.signup))
    }
}
