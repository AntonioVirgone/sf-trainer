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

    var body: some View {
        NavigationStack {
            Form {
                Section("Dati cliente") {
                    TextField("Nome", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                }

                Button("Crea Cliente") {
                    Task {
                        await createCustomer()
                    }
                }
            }
            .navigationTitle("Nuovo Cliente")
        }
    }

    private func createCustomer() async {
        print("Crea customer → \(name)")
        // Call API NestJS → POST /customers
    }
}

