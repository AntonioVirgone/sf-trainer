//
//  ExerciseLocalService.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation

class ExerciseLocalService {
    static let shared = ExerciseLocalService()
    
    private init() {}
    
    func create(_ exercise: Exercise) {
        var list = LocalDatabase.shared.exercises
        list.append(exercise)
        LocalDatabase.shared.exercises = list
    }
    
    func getAll() -> [Exercise] {
        LocalDatabase.shared.exercises
    }
}

class PlanLocalService {
    static let shared = PlanLocalService()
    
    private init() {}
    
    func create(name: String, exercises: [PlanExerciseRequest]) {
        let plan = Plan(
            id: UUID().uuidString,
            name: name,
            exercises: exercises
        )
        
        var list = LocalDatabase.shared.plans
        list.append(plan)
        LocalDatabase.shared.plans = list
    }
    
    func getAll() -> [Plan] {
        LocalDatabase.shared.plans
    }
    
    func get(by id: String) -> Plan? {
        LocalDatabase.shared.plans.first(where: { $0.id == id })
    }
}

class WorkoutLocalService {
    static let shared = WorkoutLocalService()
    
    private init() {}
    
    func create(name: String, planIds: [String]) {
        let workout = Workout(
            id: UUID().uuidString,
            name: name,
            planIds: planIds
        )
        
        var list = LocalDatabase.shared.workouts
        list.append(workout)
        LocalDatabase.shared.workouts = list
    }
    
    func getAll() -> [Workout] {
        LocalDatabase.shared.workouts
    }
    
    func get(by id: String) -> Workout? {
        LocalDatabase.shared.workouts.first(where: { $0.id == id })
    }
}
