//
//  CreateCustomerView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CreateCustomerView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var showSuccess = false

    @StateObject var vm = CustomersViewModel()
    @EnvironmentObject var tvm: TrainerViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                
                HStack(spacing: 0) {
                    
                    // MARK: - LEFT COLUMN (Customer List)
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Clienti")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding(.top, 24)
                            .padding(.horizontal)
                        
                        if vm.customers.isEmpty {
                            Text("Nessun cliente registrato")
                                .foregroundColor(.white.opacity(0.6))
                                .padding()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(vm.customers, id: \.id) { customer in
                                        CustomerRowView(customer: customer)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 12)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: 380)
                    .background(Color.black.opacity(0.20))
                    
                    
                    // MARK: - RIGHT COLUMN (Create Customer Form)
                    VStack(alignment: .leading, spacing: 32) {
                        
                        Text("Nuovo Cliente")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        // Nome
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nome")
                                .foregroundColor(.white)
                                .font(.headline)

                            SFTextField(placeholder: "Mario Rossi", text: $name)
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            SFTextField(placeholder: "example@domain.com", icon: "envelope.fill", text: $email, keyboardType: .emailAddress)
                        }
                        
                        
                        Spacer()
                        
                        // Save button
                        Button(action: { Task { await createCustomer() } }) {
                            Text("Crea Cliente")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    name.isEmpty || email.isEmpty
                                    ? Color.gray.opacity(0.4)
                                    : Color.green
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(name.isEmpty || email.isEmpty)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Gestione Clienti")
            .navigationBarTitleDisplayMode(.inline)
            .task { await loadCustomers() }
            .alert("Cliente creato!", isPresented: $showSuccess) {
                Button("OK") {}
            }
        }
    }
    
    // MARK: - LOGIC
    private func createCustomer() async {
        if let trainer = tvm.trainer {
            await vm.createCustomer(trainerCode: trainer.id!, name: name, email: email)
            
            showSuccess = true
            reset()
        }
    }

    func loadCustomers() async {
        if let trainer = tvm.trainer {
            await vm.loadCustomers(trainerCode: trainer.id!)
        }
    }

    private func reset() {
        name = ""
        email = ""
    }
}
