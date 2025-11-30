//
//  CreatePlanView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CreatePlanView: View {
    @State private var name = ""
    
    @State private var allExercises: [Exercise] = []
    @State private var selectedExerciseId: String = ""   // mai optional
    
    @State private var workoutExercises: [PlanExerciseRequest] = []
    
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            doubleColumn
        }
    }
    
    // MARK: - Vista principale con due colonne + bottone fisso
    private var doubleColumn: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                
                HStack(alignment: .top, spacing: 24) {

                    // COLONNA SINISTRA (prioritaria)
                    leftColumn
                        .layoutPriority(1)
                        .frame(maxWidth: geo.size.width * 0.7, alignment: .topLeading)

                    // COLONNA DESTRA (meno prioritaria)
                    rightColumn
                        .frame(maxWidth: geo.size.width * 0.3, alignment: .topLeading)
                        .padding(.trailing, 32)
                }
                .padding(.horizontal, 24)
                
                // Pulsante fisso
                Button(action: {
                    Task { await savePlan() }
                }) {
                    Text("Salva Plan")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(name.isEmpty || workoutExercises.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .disabled(name.isEmpty || workoutExercises.isEmpty)
                .padding()
            }
            .background(backgroundGradient)
            .navigationTitle("Nuovo Plan")
            .task { loadExercises() }
            .alert("Plan salvato!", isPresented: $saveSuccess) {
                Button("OK") {}
            }
        }
    }
    
    private var leftColumn: some View {
        VStack {
            // Nome del plan
            VStack(alignment: .leading, spacing: 8) {
                Text("Nome del plan")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("Giorno 1", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Cerchi esercizi
            VStack(alignment: .leading, spacing: 8) {
                Text("Aggiungi esercizio")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                if allExercises.isEmpty {
                    Text("Nessun esercizio disponibile")
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    ExerciseCircleGrid(
                        exercises: allExercises,
                        selectedId: $selectedExerciseId
                    )
                    .padding(.vertical)
                }
                
                Button("Aggiungi al plan") {
                    addExerciseToPlan()
                }
                .disabled(selectedExerciseId.isEmpty)
            }
            
            Spacer()
        }
    }
    
    private var rightColumn: some View {
        VStack {
            Text("Esercizi nel plan")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
            
            if workoutExercises.isEmpty {
                Text("Nessun esercizio aggiunto")
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 8)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(workoutExercises) { item in
                            if let ex = allExercises.first(where: { $0.id == item.exerciseId }) {
                                HStack {
                                    ExerciseCardView(exercise: ex, exercises: allExercises, width: 35.0, height: 35.0, imageSize: 13.0, selectedId:. constant(item.exerciseId))
                                    Spacer()
                                    Button {
                                        deleteExercise(item)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(.trailing, 10)
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.1))
                                )
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    // MARK: Funzioni
    private func loadExercises() {
        do {
            //allExercises = try await PlanApiService.shared.getAllExercises()
            allExercises = ExerciseLocalService.shared.getAll()
            if let first = allExercises.first {
                selectedExerciseId = first.id   // FIX
            }
        } catch {
            print("Errore caricamento esercizi: \(error)")
        }
    }
    
    private func addExerciseToPlan() {
        guard !selectedExerciseId.isEmpty else { return }
        
        let new = PlanExerciseRequest(
            exerciseId: selectedExerciseId,
            sets: 0,
            repetitions: 0,
            recovery: 0
        )
        
        workoutExercises.append(new)
    }
    
    private func deleteExercise(_ item: PlanExerciseRequest) {
        workoutExercises.removeAll { $0.id == item.id }
    }
    
    private func savePlan() async {
        let plan = PlanCreateRequest(
            name: name,
            exercises: workoutExercises
        )
        
        do {
            //try await PlanApiService.shared.createPlan(plan)
            PlanLocalService.shared.create(name: name, exercises: workoutExercises)
            saveSuccess = true
            reset()
        } catch {
            print("Errore salvataggio: \(error)")
        }
    }
    
    private func reset() {
        name = ""
        workoutExercises = []
    }
}
