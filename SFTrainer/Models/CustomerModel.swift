//
//  CustomerModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation

struct Customer: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let email: String?
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
