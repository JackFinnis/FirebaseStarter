//
//  SignUpView.swift
//  Ecommunity
//
//  Created by Jack Finnis on 24/09/2021.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthVM
    @FocusState var focusedField: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text(authVM.errorMessage ?? "")) {
                    TextField("First Name", text: $authVM.firstName)
                        .textContentType(.givenName)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                    TextField("Last Name", text: $authVM.lastName)
                        .textContentType(.familyName)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                    TextField("Email", text: $authVM.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                    SecureField("Password", text: $authVM.password)
                        .textContentType(.newPassword)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.join)
                }
                
                Button("Sign Up") {
                    authVM.signUp()
                }
            }
            .navigationTitle("Sign Up")
            .onSubmit {
                switch focusedField {
                case .firstName:
                    focusedField = .lastName
                case .lastName:
                    focusedField = .email
                case .email:
                    focusedField = .password
                default:
                    authVM.signUp()
                }
            }
        }
    }
}
