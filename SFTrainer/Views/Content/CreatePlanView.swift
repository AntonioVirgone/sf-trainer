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
    
    @State private var sets = 3
    @State private var reps = 10
    @State private var recovery = 60
    
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Nome del plan") {
                    TextField("Giorno 1", text: $name)
                }
                
                Section("Aggiungi esercizio") {
                    Picker("Esercizio", selection: $selectedExerciseId) {
                        ForEach(allExercises) { ex in
                            Text(ex.name).tag(ex.id)
                        }
                    }
                    
                    Stepper("Set: \(sets)", value: $sets, in: 1...10)
                    Stepper("Ripetizioni: \(reps)", value: $reps, in: 1...50)
                    Stepper("Recupero (sec): \(recovery)", value: $recovery, in: 10...300)
                    
                    Button("Aggiungi al plan") {
                        addExerciseToPlan()
                    }
                    .disabled(selectedExerciseId.isEmpty)
                }
                
                Section("Esercizi nel plan") {
                    ForEach(workoutExercises) { item in
                        let exName = allExercises.first(where: { $0.id == item.exerciseId })?.name ?? "?"
                        
                        HStack {
                            Text(exName)
                            Spacer()
                            Text("\(item.sets)x\(item.repetitions)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteExercise)
                }
                
                Section {
                    Button("Salva Plan") {
                        Task { await savePlan() }
                    }
                    .disabled(name.isEmpty || workoutExercises.isEmpty)
                }
            }
            .navigationTitle("Nuovo Plan")
            .task {
                loadExercises()
            }
            .alert("Plan salvato!", isPresented: $saveSuccess) {
                Button("OK") {}
            }
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
            sets: sets,
            repetitions: reps,
            recovery: recovery
        )
        
        workoutExercises.append(new)
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        workoutExercises.remove(atOffsets: offsets)
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
        sets = 3
        reps = 10
        recovery = 60
    }
}
