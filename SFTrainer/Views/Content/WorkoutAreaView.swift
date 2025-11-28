//
//  WorkoutAreaView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct WorkoutAreaView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Area Workout")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    Text("Gestisci esercizi, plan e workout.")
                        .foregroundColor(.white.opacity(0.7))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        
                        NavigationLink {
                            CreateExerciseView()
                        } label: {
                            FeatureCard(
                                title: "Esercizi",
                                subtitle: "Crea e gestisci gli esercizi",
                                systemImage: "figure.strengthtraining.traditional"
                            )
                        }
                        
                        NavigationLink {
                            CreatePlanView()
                        } label: {
                            FeatureCard(
                                title: "Plan",
                                subtitle: "Costruisci i giorni di allenamento",
                                systemImage: "calendar.badge.plus"
                            )
                        }
                        
                        NavigationLink {
                            CreateWorkoutView()
                        } label: {
                            FeatureCard(
                                title: "Workout",
                                subtitle: "Combina i plan in una scheda",
                                systemImage: "list.bullet.rectangle.portrait"
                            )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(backgroundGradient)        // 🔥 Funziona
            .scrollContentBackground(.hidden) // per evitare il grigio delle liste/Form
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
