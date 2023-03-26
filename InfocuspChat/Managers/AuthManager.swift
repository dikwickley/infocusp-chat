//
//  AuthManager.swift
//  InfocuspChat
//
//  Created by Aniket Singh Rawat on 27/01/23.
//

import Foundation
import Firebase
import Resolver
import SwiftUI


class AuthManager: ObservableObject {
    
    @Published var isAuth = false
    
    var firestoreManager: FirestoreManager?
    let auth = Auth.auth()
    var handle: AuthStateDidChangeListenerHandle?
    var id: String?
    
    
    init(){
        isAuth = auth.currentUser != nil
        handle = auth.addStateDidChangeListener(authStateChanged)
    }
    
    private func authStateChanged(with auth: Auth, user: User?) {
        self.isAuth = auth.currentUser != nil
        if let currentUser = auth.currentUser {
            id = currentUser.uid
        } else {
            id = nil
        }
    }
    
    func asyncLogin(email: String, password: String) async -> (AuthDataResult?, Error?) {
        do {
            return (try await auth.signIn(withEmail: email, password: password), nil)
        } catch {
            return (nil, error)
        }
    }
    
    func asyncSignup(email: String, password: String, displayName: String) async -> (AuthDataResult?, Error?) {
        do {
            if let firestoreManager = firestoreManager {
                let authDataResult = try await auth.createUser(withEmail: email, password: password)
                let changeRequest = auth.currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                try await changeRequest?.commitChanges()
                let user = ICUser(id: auth.currentUser?.uid ?? "none", name: displayName, email: email, phone: "00000-00000")
                firestoreManager.addNewUser(user: user)
                return (authDataResult, nil)
            }
        } catch {
            return (nil, error)
        }
        
        return (nil, nil)
    }
    
    func logout() {
        
        do {
            try Auth.auth().signOut()
            print("logout")
        } catch(let error) {
            debugPrint(error.localizedDescription)
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}
