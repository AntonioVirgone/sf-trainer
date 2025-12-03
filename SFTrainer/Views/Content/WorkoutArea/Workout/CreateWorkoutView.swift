//
//  CreateWorkoutView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI

struct CreateWorkoutView: View {
    @State private var name = ""
    @State private var plans: [Plan] = []
    @State private var selectedPlanIds: Set<String> = []
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                
                HStack(spacing: 0) {
                    
                    // MARK: - COLONNA SINISTRA (Lista Plans)
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Seleziona i Plan")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding()
                        
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(plans, id: \.id) { plan in
                                    PlanCard(plan: plan,
                                             isSelected: selectedPlanIds.contains(plan.id))
                                        .onTapGesture {
                                            toggleSelection(plan.id)
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: 380)
                    .background(Color.black.opacity(0.2))
                    
                    
                    // MARK: - COLONNA DESTRA (Dettaglio Workout)
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Crea Nuovo Workout")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 32)
                        
                        
                        // Nome Workout
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nome Workout")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            SFTextField(placeholder: "Scheda forza 3 giorni", text: $name)
                        }
                        
                        
                        // Lista selezionati
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Plan selezionati")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if selectedPlanIds.isEmpty {
                                Text("Nessun Plan selezionato")
                                    .foregroundColor(.white.opacity(0.5))
                            } else {
                                ForEach(plans.filter { selectedPlanIds.contains($0.id) }) { plan in
                                    Text("• \(plan.name)")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        
                        Spacer()
                        
                        // Bottone
                        Button(action: saveWorkout) {
                            Text("Crea Workout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(name.isEmpty || selectedPlanIds.isEmpty ?
                                            Color.gray.opacity(0.4) : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(name.isEmpty || selectedPlanIds.isEmpty)
                        
                        Spacer(minLength: 40)
                        
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Nuovo Workout")
            .navigationBarTitleDisplayMode(.inline)
            .task { loadPlans() }
            .alert("Workout creato!", isPresented: $saveSuccess) {
                Button("OK") {}
            }
        }
    }
    
    // MARK: - LOGICA
    private func toggleSelection(_ id: String) {
        if selectedPlanIds.contains(id) { selectedPlanIds.remove(id) }
        else { selectedPlanIds.insert(id) }
    }
    
    private func loadPlans() {
        plans = PlanLocalService.shared.getAll()
    }
    
    private func saveWorkout() {
        WorkoutLocalService.shared.create(
            name: name,
            planIds: Array(selectedPlanIds)
        )
        
        saveSuccess = true
        reset()
    }
    
    private func reset() {
        name = ""
        selectedPlanIds = []
    }
}

