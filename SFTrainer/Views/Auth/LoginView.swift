//
//  LoginView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 19/11/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var apiService: UserApiService
    
    @Binding var showRegister: Bool
    
    @State private var onClickRequest = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var loading = false
    @State private var errorMessage = ""
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        VStack {
            VStack {
                // MARK: - Logo
                logo.padding(.top, 20)
                
                // MARK: - TextEdit per inserire username e password
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                            TextField("Username", text: $username)
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal)
                
                // MARK: - Separator
                separator(circleColor: primryColor, isLoading: loading)
                    .padding(.vertical, 10)
                
                // MARK: - Login button
                loginButton
                    .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(primryColor, lineWidth: 1)   // 👈 Cornice sottile
            )
            .padding(20)
            
            Button(action: {
                showRegister = true   // 👈 Passa alla schermata di registrazione
            }) {
                Text("Registrati")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(primryColor)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing], 35)
            
        }
    }
    
    private var loginButton: some View {
        VStack {
            Button{
                Task {
                    loading = true
                    let ok = await apiService.login(username: username, password: password)
                    loading = false
                    
                    if !ok {
                        errorMessage = "Credenziali non valide"
                    }
                }
            } label: {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)     // 🔥 prende tutta la larghezza possibile
                    .background(secundaryColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)               // 🔥 margine dai bordi
            .disabled(loading)
        }
    }
}
