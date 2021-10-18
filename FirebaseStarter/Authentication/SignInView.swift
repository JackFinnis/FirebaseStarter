//
//  SignInView.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authVM: AuthVM
    @State var showSignUpView: Bool = false
    @FocusState var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text(authVM.errorMessage ?? "")) {
                    TextField("Email", text: $authVM.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                    SecureField("Password", text: $authVM.password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                }
                
                Button("Sign In") {
                    authVM.signIn()
                }
            }
            .navigationTitle("Sign In")
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                default:
                    authVM.signIn()
                }
            }
            .toolbar {
                Button("Sign up") {
                    authVM.reset()
                    showSignUpView = true
                }
            }
        }
        .sheet(isPresented: $showSignUpView, onDismiss: {
            authVM.reset()
        }) {
            SignUpView()
                .environmentObject(authVM)
        }
    }
}
