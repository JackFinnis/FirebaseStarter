//
//  AuthView.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authVM = AuthVM()
    
    var body: some View {
        Group {
            if authVM.userID == nil {
                SignInView()
            } else {
                Button("Sign Out") {
                    authVM.signOut()
                }
            }
        }
        .environmentObject(authVM)
        .onAppear {
            authVM.addAuthListener()
        }
    }
}
