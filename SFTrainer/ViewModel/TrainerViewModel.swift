//
//  TrainerViewModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class TrainerViewModel: ObservableObject {
    @Published var trainer: Trainer?
    
    private let api = ApiService()

    init() {
        loadTrainer()
    }
    
    // MARK: LOCAL OPERATION
    func saveTrainer() {
        guard let trainer else {
            UserDefaults.standard.removeObject(forKey: "trainer")
            return
        }

        if let encoded = try? JSONEncoder().encode(trainer) {
            UserDefaults.standard.set(encoded, forKey: "trainer")
        }
    }

    func loadTrainer() {
        if let data = UserDefaults.standard.data(forKey: "trainer"),
           let decoded = try? JSONDecoder().decode(Trainer.self, from: data) {
            self.trainer = decoded
        }
    }
    
    func removeTrainer() {
        self.trainer = nil
        UserDefaults.standard.removeObject(forKey: "trainer")
    }
    
    // MARK: SERVER OPERATION
    // ---- GET ----
    func loadTrainer(trainerCode: String) async {
        do {
            let result: Trainer = try await api.get("/trainer/\(trainerCode)")
            print(result)
            self.trainer = result
        } catch {
            print("Errore GET: ", error)
        }
    }
    
    // ---- POST LOGIN ----
    func loginTrainer(name: String, password: String) async throws {
        struct LoginTrainerRequest: Codable {
            let name: String
            let password: String
        }

        do {
            let body = LoginTrainerRequest(name: name, password: password)
            
            let loginTrainer: Trainer = try await api.post("/trainer/login", body: body)
            
            print(loginTrainer)
            
            trainer = loginTrainer
        } catch {
            print("Errore [POST] createTrainer: ", error)
            throw error   // 🔥 RILANCIA L’ERRORE QUI
        }
    }
    
    // ---- POST SIGNIN ----
    func createTrainer(name: String, email: String, password: String) async throws {
        struct CreateTrainerRequest: Codable {
            let name: String
            let email: String
            let password: String
        }

        do {
            let body = CreateTrainerRequest(name: name, email: email, password: password)
            
            let newTrainer: Trainer = try await api.post("/trainer", body: body)
            
            print(newTrainer)
            
            trainer = newTrainer
        } catch {
            print("Errore [POST] createTrainer: ", error)
            throw error   // 🔥 RILANCIA L’ERRORE QUI
        }
    }

}
