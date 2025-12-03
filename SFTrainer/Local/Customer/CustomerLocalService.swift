//
//  CustomerLocalService.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation

class CustomerLocalService {
    
    static let shared = CustomerLocalService()
    
    private init() {}
    
    func create(_ customer: Customer) {
        var list = CustomerLocalDatabase.shared.customers
        list.append(customer)
        CustomerLocalDatabase.shared.customers = list
    }
    
    func getAll() -> [Customer] {
        CustomerLocalDatabase.shared.customers
    }
}

class AssignedWorkoutLocalStore {
    static let shared = AssignedWorkoutLocalStore()

    private let key = "assigned_workouts"

    // customerId → [workoutId]
    private var storage: [String: [String]] = [:]

    private init() {
        load()
    }

    func assign(workoutId: String, to customerId: String) {
        var current = storage[customerId] ?? []
        if !current.contains(workoutId) {
            current.append(workoutId)
        }
        storage[customerId] = current
        save()
    }

    func getAssignedWorkouts(for customerId: String) -> [String] {
        return storage[customerId] ?? []
    }

    private func save() {
        if let data = try? JSONEncoder().encode(storage) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: [String]].self, from: data)
        else { return }
        
        storage = decoded
    }
}
