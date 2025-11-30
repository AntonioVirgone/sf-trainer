//
//  CreateExerciseView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CreateExerciseView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var imageName = ""
    @State private var muscleGroup = MuscleGroupType.gambe
    @State private var sets = 0
    @State private var repetitions = 0
    @State private var recovery = 0
    @State private var instructions: [String] = []
    
    @State private var newInstruction = ""
    @State private var isSaving = false
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Info esercizio") {
                    TextField("Nome", text: $name)
                    TextField("Descrizione", text: $description)
                    TextField("Nome immagine", text: $imageName)
                    Section("Gruppo Muscolare") {
                        Picker("Seleziona gruppo", selection: $muscleGroup) {
                            ForEach(MuscleGroupType.allCases) { group in
                                Text(group.rawValue).tag(group)
                            }
                        }
                    }
                }
                
                Section("Parametri base") {
                    Stepper("Set: \(sets)", value: $sets, in: 0...10)
                    Stepper("Ripetizioni: \(repetitions)", value: $repetitions, in: 0...50)
                    Stepper("Recupero (sec): \(recovery)", value: $recovery, in: 0...300)
                }
                
                Section("Istruzioni") {
                    ForEach(instructions, id: \.self) { instr in
                        Text(instr)
                    }
                    .onDelete { offsets in
                        instructions.remove(atOffsets: offsets)
                    }
                    
                    HStack {
                        TextField("Nuova istruzione", text: $newInstruction)
                        Button("Aggiungi") {
                            if !newInstruction.isEmpty {
                                instructions.append(newInstruction)
                                newInstruction = ""
                            }
                        }
                    }
                }
                
                Section {
                    Button("Salva esercizio") {
                        Task { await saveExercise() }
                    }
                    .disabled(name.isEmpty)
                }
            }
            .background(backgroundGradient)        // 🔥 Funziona
            .navigationTitle("Nuovo esercizio")
            .alert("Esercizio salvato!", isPresented: $saveSuccess) {
                Button("OK") {}
            }
        }
    }
    
    private func saveExercise() async {
        isSaving = true
        
        let exercise = Exercise(
            name: name,
            description: description,
            imageName: imageName,
            muscleGroup: muscleGroup,
            sets: sets,
            repetitions: repetitions,
            recovery: recovery,
            instructions: instructions
        )
        
        do {
            try await ExerciseLocalService.shared.create(exercise)
            saveSuccess = true
            resetForm()
        } catch {
            print("Errore salvataggio: \(error)")
        }
        
        isSaving = false
    }
    
    private func resetForm() {
        name = ""
        description = ""
        imageName = ""
        MuscleGroupType.braccia
        sets = 0
        repetitions = 0
        recovery = 0
        instructions = []
    }
}
