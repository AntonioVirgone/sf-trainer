//
//  AssignWorkoutSheetView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI

struct AssignWorkoutSheetView: View {
    let customer: Customer
    let onAssigned: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var workouts: [Workout] = []
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Assegna Workout a \(customer.name)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(workouts) { workout in
                            WorkoutRow(workout: workout)
                                .onTapGesture {
                                    assign(workout)
                                }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(30)
        }
        .task { loadWorkouts() }
    }
    
    private func loadWorkouts() {
        workouts = WorkoutLocalService.shared.getAll()
    }
    
    private func assign(_ workout: Workout) {
        AssignedWorkoutLocalStore.shared.assign(
            workoutId: workout.id,
            to: customer.id
        )
        
        onAssigned()   // aggiorna la colonna 3
        dismiss()
    }
}
