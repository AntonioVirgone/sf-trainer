//
//  ClientsListView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 23/11/25.
//

import Foundation
import SwiftUI

struct TrainerMainView: View {
    @EnvironmentObject var auth: UserApiService   // se già lo usi
    
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
                
                AssignWorkoutView()
                    .tabItem {
                        Label("Assegna", systemImage: "link")
                    }
                
                CustomerDashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "person.text.rectangle")
                    }
            }
            // colore di selezione tab
            .scrollContentBackground(.hidden)      // se ci sono List / ScrollView
            .tint(.green)        }
    }
}
