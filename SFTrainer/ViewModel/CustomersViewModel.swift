//
//  CustomersViewModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class CustomersViewModel: ObservableObject {
    @Published var customers: [Customer] = []

    private let api = ApiService()

    // ---- GET ----
    func loadCustomers(trainerCode: String) async {
        do {
            let result: [Customer] = try await api.get("/customers/\(trainerCode)")
            print(result)
            self.customers = result
        } catch {
            print("Errore GET:", error)
        }
    }

    // ---- POST ----
    func createCustomer(trainerCode: String, name: String, email: String?) async {
        struct CreateCustomerRequest: Codable {
            let name: String
            let email: String?
        }

        do {
            let body = CreateCustomerRequest(name: name, email: email)
            let newCustomer: Customer = try await api.post("/customers/\(trainerCode)", body: body)
            
            print(newCustomer)
            
            customers.append(newCustomer)
        } catch {
            print("Errore POST:", error)
        }
    }

    // ---- DELETE ----
    func deleteCustomer(id: String) async {
        do {
            try await api.delete("/customers/\(id)")
            customers.removeAll { $0.id == id }
        } catch {
            print("Errore DELETE:", error)
        }
    }
}
