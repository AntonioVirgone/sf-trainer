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
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(exercises) { ex in
                exerciseCardView(ex: ex)
            }
        }
    }
    
    private func exerciseCardView(ex: Exercise) -> some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(radius: 5, y: 3)
            
            // Content inside the card
            HStack(spacing: 16) {
                
                // Cerchio a sinistra
                ZStack {
                    Circle()
                        .fill(color(for: ex))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(
                                    selectedId == ex.id ? Color.white : .clear,
                                    lineWidth: 4
                                )
                        )
                        .shadow(radius: 4)
                    
                    Image(systemName: icon(for: ex))
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
                
                // Testi a destra
                VStack(alignment: .leading, spacing: 4) {
                    Text(ex.name)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.95))
                    
                    Text(ex.muscleGroup.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(20)   // 👈 Padding richiesto su tutti i lati
        }
        .onTapGesture {
            selectedId = ex.id
        }
    }
        
    // MARK: - Colori diversi per esercizio
    private func color(for ex: Exercise) -> Color {
        let index = exercises.firstIndex(where: { $0.id == ex.id }) ?? 0
        let colors: [Color] = [
            .blue, .green, .orange, .pink, .purple, .teal, .red,
        ]
        return colors[index % colors.count]
    }
    
    // MARK: - Icona associata (puoi personalizzare)
    private func icon(for ex: Exercise) -> String {
        // se hai un campo "imageName" così: ex.imageName
        // return ex.imageName
        
        // fallback: icona in base al muscolo oppure generica
        switch ex.muscleGroup {
        case MuscleGroupType.braccia: return "dumbbell"
        case MuscleGroupType.schiena:
            return "figure.strengthtraining.functional"
        case MuscleGroupType.gambe: return "figure.run"
        case MuscleGroupType.spalle: return "bolt"
        case MuscleGroupType.petto: return "figure.strengthtraining.traditional"
        default: return "dumbbell"
        }
    }
}

