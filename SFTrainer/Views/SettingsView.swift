//
//  SettingsView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: TrainerViewModel
    @State private var stayLoggedIn: Bool = UserDefaults.standard.bool(forKey: "stayLoggedIn")

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 30) {

                    // MARK: - Titolo
                    Text("Impostazioni")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    // MARK: - Card Profilo
                    VStack(spacing: 16) {
                        if let trainer = vm.trainer {
                            HStack(spacing: 16) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(primryColor)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(trainer.name)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)

                                    if let email = trainer.email {
                                        Text(email)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }

                                Spacer()
                            }

                            Divider()
                                .background(Color.white.opacity(0.3))
                        }

                        // MARK: - Toggle "Rimani connesso"
                        Toggle(isOn: $stayLoggedIn) {
                            Text("Rimani connesso")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: primryColor))

                    }
                    .padding(24)
                    .frame(maxWidth: 600)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(primryColor.opacity(0.5), lineWidth: 1)
                    )

                    // MARK: - Logout Button
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                        vm.removeTrainer()
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 600)
                    }
                    .background(Color.red.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.top, 20)

                }

                Spacer()
            }
        }
    }
}
