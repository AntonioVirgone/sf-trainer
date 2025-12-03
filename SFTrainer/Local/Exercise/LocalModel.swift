//
//  LocalModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: String       // mai optional
    
    var name: String
    var description: String
    var imageName: String
    var muscleGroup: MuscleGroupType
    var sets: Int
    var repetitions: Int
    var recovery: Int
    var instructions: [String]
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        imageName: String,
        muscleGroup: MuscleGroupType,
        sets: Int,
        repetitions: Int,
        recovery: Int,
        instructions: [String]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.muscleGroup = muscleGroup
        self.sets = sets
        self.repetitions = repetitions
        self.recovery = recovery
        self.instructions = instructions
    }
}

enum MuscleGroupType: String, CaseIterable, Codable, Identifiable {
    case petto = "Petto"
    case schiena = "Schiena"
    case spalle = "Spalle"
    case gambe = "Gambe"
    case braccia = "Braccia"
    case core = "Core"

    var id: String { self.rawValue }
}

struct Plan: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var exercises: [PlanExerciseRequest]
}

struct PlanExerciseRequest: Identifiable, Codable, Hashable {
    var id = UUID()
    let exerciseId: String
    let sets: Int
    let repetitions: Int
    let recovery: Int
}

struct Workout: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let planIds: [String]
}
