//
//  CreateCustomerView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CreateCustomerView: View {
    @State private var customers: [Customer] = []      // Lista per colonna sinistra
    @State private var name = ""
    @State private var email = ""
    @State private var showSuccess = false
    
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
                        
                        if customers.isEmpty {
                            Text("Nessun cliente registrato")
                                .foregroundColor(.white.opacity(0.6))
                                .padding()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(customers, id: \.id) { customer in
                                        CustomerRow(customer: customer)
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
                            
                            TextField("Mario Rossi", text: $name)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            TextField("email@example.com", text: $email)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.none)
                                .cornerRadius(12)
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
            .task { loadCustomers() }
            .alert("Cliente creato!", isPresented: $showSuccess) {
                Button("OK") {}
            }
        }
    }
    
    // MARK: - LOGIC
    private func createCustomer() async {
        let newCustomer = Customer(id: UUID().uuidString, name: name, email: email)
        
        customers.append(newCustomer)
        
        // TODO: integrazione con API NestJS
        // try await CustomerApiService.shared.create(name: name, email: email)
        CustomerLocalService.shared.create(newCustomer)
        
        showSuccess = true
        reset()
    }
    
    private func loadCustomers() {
        // TODO: Caricare dal backend
        customers = CustomerLocalService.shared.getAll()
    }
    
    private func reset() {
        name = ""
        email = ""
    }
}

struct CustomerRow: View {
    let customer: Customer
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(customer.email!)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }
}
