//
//  LoginView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 19/11/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var vm: TrainerViewModel

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var stayLoggedIn: Bool = UserDefaults.standard.bool(forKey: "stayLoggedIn")

    @State private var loading = false
    @Binding var showRegister: Bool

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack {
                Spacer()

                // MARK: - Centro (Card)
                VStack(spacing: 32) {

                    // MARK: - Logo
                    logo
                        .padding(.top, 20)

                    // MARK: - Titolo App
                    Text("Accedi al tuo account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    // MARK: - Campi input
                    VStack(spacing: 20) {
                        SFTextField(placeholder: "Username", icon: "person.fill", text: $username)
                        SFTextField(placeholder: "Password", icon: "lock.fill", text: $password, isSecure: true)

                        // MARK: - Stay Logged In
                        Toggle(isOn: $stayLoggedIn) {
                            Text("Rimani connesso")
                                .foregroundColor(.white)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: primryColor))
                    }
                    .padding(.horizontal, 60)

                    // MARK: - Login Button
                    Button {
                        Task {
                            await performLogin()
                        }
                    } label: {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Accedi")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .background(primryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 60)

                    // MARK: - Separator
                    separator(circleColor: primryColor, isLoading: loading)
                        .padding(.vertical, 8)

                    // MARK: - Register
                    Button(action: {
                        showRegister = true
                    }) {
                        Text("Crea un nuovo account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(secundaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 60)

                }
                .frame(maxWidth: 600)  // 🔥 Perfetto per iPad
                .padding()
                .background(Color.black.opacity(0.25))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primryColor.opacity(0.5), lineWidth: 1)
                )

                Spacer()
            }
        }
    }

    // MARK: - Login Logic
    private func performLogin() async {
        loading = true
        defer { loading = false }

        do {
            try await vm.loginTrainer(name: username, password: password)

            // SALVA LA PREFERENZA per la prossima apertura
            UserDefaults.standard.set(stayLoggedIn, forKey: "stayLoggedIn")

            if stayLoggedIn {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.vm.saveTrainer()
            }

        } catch {
            print("Errore login:", error)
        }
    }
}
