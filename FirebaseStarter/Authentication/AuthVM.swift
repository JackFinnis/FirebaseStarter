//
//  AuthVM.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthVM: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var userID: String?
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let helper = FirebaseHelper()
    
    // MARK: - Listeners
    func addAuthListener() {
        auth.addStateDidChangeListener { auth, user in
            self.userID = user?.uid
        }
    }
    
    // MARK: - Auth State
    func signUp() {
        if let error = validate() {
            errorMessage = error
            return
        }
        
        reset()
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.createAccount()
        }
    }
    
    func validate() -> String? {
        if firstName.isEmpty {
            return "Please enter your first name"
        } else if lastName.isEmpty {
            return "Please enter your last name"
        } else if email.isEmpty {
            return "Please enter your email"
        } else if password.isEmpty {
            return "Please enter your password"
        }
        return nil
    }
    
    func signIn() {
        reset()
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
    }
    
    func reset() {
        errorMessage = nil
    }
    
    // MARK: - Firebase
    func createAccount() {
        if let userID = auth.currentUser?.uid {
            db.collection("users").document(userID).setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email
            ])
        }
    }
}
