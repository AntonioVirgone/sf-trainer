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
        var list = ExerciseLocalDatabase.shared.exercises
        list.append(exercise)
        ExerciseLocalDatabase.shared.exercises = list
    }
    
    func getAll() -> [Exercise] {
        ExerciseLocalDatabase.shared.exercises
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
        
        var list = ExerciseLocalDatabase.shared.plans
        list.append(plan)
        ExerciseLocalDatabase.shared.plans = list
    }
    
    func getAll() -> [Plan] {
        ExerciseLocalDatabase.shared.plans
    }
    
    func get(by id: String) -> Plan? {
        ExerciseLocalDatabase.shared.plans.first(where: { $0.id == id })
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
        
        var list = ExerciseLocalDatabase.shared.workouts
        list.append(workout)
        ExerciseLocalDatabase.shared.workouts = list
    }
    
    func getAll() -> [Workout] {
        ExerciseLocalDatabase.shared.workouts
    }
    
    func get(by id: String) -> Workout? {
        ExerciseLocalDatabase.shared.workouts.first(where: { $0.id == id })
    }
}
