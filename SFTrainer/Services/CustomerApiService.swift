//
//  CustomerApiService.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation

class CustomerApiService {
    static let shared = CustomerApiService()

    private init() {}

    func getAllCustomers() async throws -> [Customer] {
        guard let url = URL(string: "baseUrl/customers") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Customer].self, from: data)
    }
    
    func getCustomerWorkout(customerId: String) async throws -> CustomerWorkout {
        let url = URL(string: "baseUrl/customers/\(customerId)/workout")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CustomerWorkout.self, from: data)
    }
    
    func getCustomerHistory(customerId: String) async throws -> [ExerciseHistoryEntry] {
        let url = URL(string: "baseUrl/customers/\(customerId)/history")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ExerciseHistoryEntry].self, from: data)
    }
}

struct CustomerWorkout: Codable, Hashable {
    let name: String
    let planNames: [String]
}

struct ExerciseHistoryEntry: Identifiable, Codable, Hashable {
    let id: String
    let date: String
    let exerciseName: String
    let reps: Int
    let sets: Int
}
