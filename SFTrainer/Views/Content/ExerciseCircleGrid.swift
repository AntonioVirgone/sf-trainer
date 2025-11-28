//
//  ExerciseCircleGrid.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation
import SwiftUI

struct ExerciseCircleGrid: View {
    let exercises: [Exercise]
    @Binding var selectedId: String
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(exercises) { ex in
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(color(for: ex))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(selectedId == ex.id ? Color.white : .clear, lineWidth: 4)
                            )
                            .shadow(radius: 4)
                        
                        Image(systemName: icon(for: ex))
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    }
                    
                    Text(ex.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                }
                .onTapGesture {
                    selectedId = ex.id
                }
            }
        }
    }
    
    // MARK: - Colori diversi per esercizio
    private func color(for ex: Exercise) -> Color {
        let index = exercises.firstIndex(where: { $0.id == ex.id }) ?? 0
        let colors: [Color] = [
            .blue, .green, .orange, .pink, .purple, .teal, .red
        ]
        return colors[index % colors.count]
    }
    
    // MARK: - Icona associata (puoi personalizzare)
    private func icon(for ex: Exercise) -> String {
        // se hai un campo "imageName" così: ex.imageName
        // return ex.imageName
        
        // fallback: icona in base al muscolo oppure generica
        switch ex.muscleGroup.lowercased() {
        case "petto": return "dumbbell"
        case "schiena": return "figure.strengthtraining.functional"
        case "gambe": return "figure.run"
        case "spalle": return "bolt"
        default: return "dumbbell"
        }
    }
}

