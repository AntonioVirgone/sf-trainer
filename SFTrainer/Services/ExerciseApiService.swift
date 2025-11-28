//
//  ExerciseApiService.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation
import SwiftUI

class ExerciseApiService {
    static let shared = ExerciseApiService()

    let baseURL: String = "https://training-backend-api.herokuapp.com"

    private init() {
        
    }

    func createExercise(_ exercise: Exercise) async throws {
        guard let url = URL(string: "\(baseURL)/exercise") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(exercise)

        _ = try await URLSession.shared.data(for: request)
    }
    
    func getAllExercises() async throws -> [Exercise] {
        guard let url = URL(string: "\(baseURL)/exercise") else { return [] }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Exercise].self, from: data)
    }
}
