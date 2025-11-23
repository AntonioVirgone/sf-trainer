//
//  SFTrainerApp.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 23/11/25.
//

import SwiftUI

@main
struct SmartFitTrainerApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .preferredColorScheme(.light)
                .onAppear {
                    print("🚀 GymBro avviato!")
                    print("📱 iOS Version: \(UIDevice.current.systemVersion)")
                    // Forza il rendering immediato
                    setupWindow()
                }
        }
    }
    
    // MARK: - UI Appearence Setup
    private func configureNavigationBarAppearance() {
        // Personalizzazione globale dell'app (aggiungeremo dopo)
        print("🎨 Configurazione stile della Navigation Bar...")

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // ✅ rende la barra trasparente
        
        // Titolo bianco
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Applica a TUTTE le possibili varianti
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Colore pulsanti (es: freccia "indietro")
        UINavigationBar.appearance().tintColor = .white
    }
    
    private func setupAppearance() {
        // Configura l'aspetto globale per evitare ritardi
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    private func setupWindow() {
        // Assicura che la window sia configurata correttamente
        if let window = UIApplication.shared.windows.first {
            window.backgroundColor = .systemBackground
        }
    }
}
