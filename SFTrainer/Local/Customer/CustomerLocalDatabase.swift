//
//  LocalDatabase.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation

class CustomerLocalDatabase {
    static let shared = CustomerLocalDatabase()
    
    private let key = "customer_local_db"
    
    struct DBModel: Codable {
        var customers: [Customer] = []
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
    var customers: [Customer] {
        get { db.customers }
        set { db.customers = newValue; save() }
    }
}
