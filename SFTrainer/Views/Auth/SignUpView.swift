//
//  SignUpView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 19/11/25.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm: TrainerViewModel

    @Binding var showRegister: Bool

    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var newMail: String = ""

    @State private var loading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack {
                Spacer()

                // MARK: - Card principale
                VStack(spacing: 32) {

                    // MARK: Logo
                    logo
                        .padding(.top, 20)

                    // MARK: Titolo
                    Text("Crea un nuovo account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    // MARK: Fields
                    VStack(spacing: 20) {
                        SFTextField(placeholder: "Username", icon: "person.fill", text: $newUsername)
                        SFTextField(placeholder: "Email", icon: "envelope.fill", text: $newMail)
                        SFTextField(placeholder: "Password", icon: "lock.fill", text: $newPassword, isSecure: true)
                    }
                    .padding(.horizontal, 60)

                    // MARK: pulsante di registrazione
                    Button {
                        Task { await performSignUp() }
                    } label: {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Crea account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .background(primryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 60)

                    // MARK: Separator
                    separator(circleColor: primryColor, isLoading: loading)
                        .padding(.vertical, 8)

                    // MARK: Torna al login
                    Button(action: { showRegister = false }) {
                        Text("Torna al Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(secundaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 60)

                }
                .frame(maxWidth: 600)
                .padding()
                .background(Color.black.opacity(0.25))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(secundaryColor.opacity(0.5), lineWidth: 1)
                )

                Spacer()
            }
        }
        .alert("Errore", isPresented: Binding(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil })
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Si è verificato un errore.")
        }
    }

    // MARK: - Signup Logic
    private func performSignUp() async {
        loading = true
        defer { loading = false }

        guard !newUsername.isEmpty,
              !newMail.isEmpty,
              !newPassword.isEmpty else {
            errorMessage = "Tutti i campi sono obbligatori."
            return
        }

        do {
            try await vm.createTrainer(
                name: newUsername,
                email: newMail,
                password: newPassword
            )

            // Torna al login dopo la creazione
            showRegister = false

        } catch {
            errorMessage = "Errore durante la registrazione. Riprova."
            print("Signup error:", error)
        }
    }
}
