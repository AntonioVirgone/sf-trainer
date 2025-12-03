//
//  TrainerModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//

import Foundation

struct Trainer: Codable {
    var id: String?
    var name: String
    var password: String?
    var email: String?
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    init(name: String, password: String, email: String) {
        self.name = name
        self.password = password
        self.email = email
    }
    
    init(id: String, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
        self.email = email
    }
}
