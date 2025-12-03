//
//  ExerciseViewModel.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []

    private let api = ApiService()

    // ---- GET ----
    func loadExercises(trainerCode: String) async {
        do {
            let result: [Exercise] = try await api.get("/customers/\(trainerCode)")
            print(result)
            self.exercises = result
        } catch {
            print("Errore GET:", error)
        }
    }

}
