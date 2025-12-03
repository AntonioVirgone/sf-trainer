//
//  ClientsListView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 23/11/25.
//

import Foundation
import SwiftUI

struct TrainerMainView: View {
    @EnvironmentObject var vm: TrainerViewModel
    
    var body: some View {
        ZStack {
            TabView {
                WorkoutAreaView()
                    .tabItem {
                        Label("Workout", systemImage: "dumbbell.fill")
                    }
                
                CustomersAreaView()
                    .tabItem {
                        Label("Clienti", systemImage: "person.3.fill")
                    }
                
                CustomersDashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "person.text.rectangle")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            // colore di selezione tab
            .scrollContentBackground(.hidden)      // se ci sono List / ScrollView
            .tint(.green)
        }
    }
}
