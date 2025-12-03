//
//  LaunchScreenView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 22/11/25.
//

import Foundation
import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    private let pingService = ApiService()

    var body: some View {
        if isActive {
            // Qui va la tua vista principale
            ContentView()
        } else {
            ZStack {
                // Sfondo (puoi personalizzare)
                backgroundGradient
                
                VStack {
                    // Logo o icona dell'app
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    // Nome dell'app
                    Text("SmartFitTrainer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Sottotitolo opzionale
                    Text("To Fitness Training")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 5)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // Tempo di visualizzazione della launch screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .task {
                await wakeServerAndStart()
            }
        }
    }
    
    /// Attende IN PARALLELO sia l'animazione che la chiamata API
    private func wakeServerAndStart() async {
        async let wakeCall: () = pingService.wakeServer()
        async let animationDelay: () = delayForAnimation()

        _ = await (wakeCall, animationDelay)

        withAnimation {
            isActive = true
        }
    }

    /// Questo attende che l’animazione della launch duri un minimo di 2 secondi
    private func delayForAnimation() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
}

#Preview {
    LaunchScreenView()
}
