//
//  WorkoutModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation

struct WorkoutExerciseRequest: Codable, Identifiable {
    var id = UUID()
    let exerciseId: String   // id dell’esercizio scelto dal DB
    let sets: Int
    let reps: Int
    let recovery: Int
}

struct PlanCreateRequest: Codable {
    var name: String
    let exercises: [PlanExerciseRequest]
}


struct WorkoutCreateRequest: Codable {
    let name: String
    let planIds: [String]
}
