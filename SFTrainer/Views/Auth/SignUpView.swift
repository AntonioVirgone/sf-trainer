//
//  SignUpView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 19/11/25.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var apiService: UserApiService

    @Binding var showRegister: Bool

    @State private var onClickRequest = false

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var newMail: String = ""

    var body: some View {
        VStack {
            VStack {
                // MARK: - Logo
                logo.padding(.top, 20)

                // MARK: - Create new account
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                            TextField("Username", text: $newUsername)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "envelope.fill")
                            TextField("Mail", text: $newMail)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $newPassword)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal)
                
                // MARK: - Separator
                separator(circleColor: secundaryColor, isLoading: false)
                    .padding(.vertical, 10)
                
                // MARK: Create new account
                signupButton
                    .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(secundaryColor, lineWidth: 1)   // 👈 Cornice sottile
            )
            .padding(20)
            
            Button(action: {
                showRegister = false   // 👈 Torna indietro senza registrarsi
            }) {
                Text("Torna al Login")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(secundaryColor)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing], 35)        }
    }
    
    private var signupButton: some View {
        VStack {
            Button(action: {
                self.onClickRequest = true
                // apiService.signUp(user: User(username: username, password: password, email: newMail))
            }) {
                Text("Create new account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(primryColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)               // 🔥 margine dai bordi
            .disabled(false)            
        }
    }
    
}
