//
//  LocalDatabase.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation

class LocalDatabase {
    static let shared = LocalDatabase()
    
    private let key = "smartfit_local_db"
    
    struct DBModel: Codable {
        var exercises: [Exercise] = []
        var plans: [Plan] = []
        var workouts: [Workout] = []
    }
    
    private init() {
        load()
    }
    
    private var db = DBModel()
    
    // MARK: LOAD
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(DBModel.self, from: data) {
            self.db = decoded
        }
    }
    
    // MARK: SAVE
    private func save() {
        if let encoded = try? JSONEncoder().encode(db) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    // MARK: Accessors
    var exercises: [Exercise] {
        get { db.exercises }
        set { db.exercises = newValue; save() }
    }
    
    var plans: [Plan] {
        get { db.plans }
        set { db.plans = newValue; save() }
    }
    
    var workouts: [Workout] {
        get { db.workouts }
        set { db.workouts = newValue; save() }
    }
}
