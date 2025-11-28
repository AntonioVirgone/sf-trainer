//
//  AssignWorkoutView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct AssignWorkoutView: View {
    @State private var customers: [Customer] = []
    @State private var workouts: [Workout] = []
    @State private var selectedCustomer: Customer?
    @State private var selectedWorkout: Workout?

    var body: some View {
        NavigationStack {
            Form {
                Section("Cliente") {
                    Picker("Seleziona cliente", selection: $selectedCustomer) {
                        ForEach(customers) { customer in
                            Text(customer.name).tag(Optional(customer))
                        }
                    }
                }

                Section("Workout") {
                    Picker("Seleziona workout", selection: $selectedWorkout) {
                        ForEach(workouts) { workout in
                            Text(workout.name).tag(Optional(workout))
                        }
                    }
                }

                Button("Assegna Workout") {
                    Task { await assign() }
                }
                .disabled(selectedCustomer == nil || selectedWorkout == nil)
            }
            .background(backgroundGradient)        // 🔥 Funziona
            .navigationTitle("Assegna Workout")
            .task {
                await loadData()
            }
        }
    }

    private func loadData() async {
        // GET /customers
        // GET /workouts
        workouts = WorkoutLocalService.shared.getAll()
    }

    private func assign() async {
        // POST /assign
    }
}
