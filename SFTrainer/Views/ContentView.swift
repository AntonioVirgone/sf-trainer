//
//  ContentView.swift
//  SmartFitTrainer
//
//  Created by Antonio Virgone on 22/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    private let dataOrigin = "REMOTE"
    
    // MARK: - Environment Objects
    @StateObject private var userApiService = UserApiService()
    
    @State private var showingMenu = false
    
    var isLogged: Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn");
    }
    
    var body: some View {
        ZStack {
            // 🔹 Sfondo gradiente
            backgroundGradient
            
            AuthView()
                .environmentObject(userApiService)
        }
    }
}
