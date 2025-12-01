//
//  CustomerDashboardView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CustomersDashboardView: View {
    @State private var customers: [Customer] = []
    @State private var selectedCustomer: Customer? = nil
    @State private var assignedWorkouts: [Workout] = []   // Caricati solo quando selezioni il cliente

    @State private var showAssignWorkout = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()

                HStack(spacing: 0) {

                    // MARK: - COLUMN 1: Customer List
                    customerList
                        .frame(maxWidth: 350)
                        .background(Color.black.opacity(0.22))

                    Divider().background(Color.white.opacity(0.2))

                    // MARK: - COLUMN 2: Customer Detail
                    customerDetail
                        .frame(maxWidth: 400)
                    
                    Divider().background(Color.white.opacity(0.2))

                    // MARK: - COLUMN 3: Assigned Workouts
                    workoutList
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Gestione Clienti")
            .task { loadCustomers() }
        }
    }
}

extension CustomersDashboardView {
    var customerList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Clienti")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(.top, 24)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(customers) { customer in
                        CustomerRowDash(customer: customer,
                                    isSelected: selectedCustomer?.id == customer.id)
                            .onTapGesture {
                                selectedCustomer = customer
                                loadAssignedWorkouts(for: customer)
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct CustomerRowDash: View {
    let customer: Customer
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(customer.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Text(customer.email!)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.green.opacity(0.35) : Color.white.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}

extension CustomersDashboardView {
    var customerDetail: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            if let c = selectedCustomer {
                
                Text(c.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text(c.email!)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.title3)
                
                Spacer().frame(height: 20)
                
                // ACTIONS
                VStack(spacing: 16) {
                    dashboardButton("Assegna Workout", icon: "link") {
                        // Apri flusso assegnazione workout
                        showAssignWorkout = true
                    }
                    
                    dashboardButton("Modifica Cliente", icon: "pencil") {
                        // Apri edit
                    }
                    dashboardButton("Cronologia Esercizi", icon: "clock") {
                        // Apri storico
                    }
                }
                
                Spacer()
                
            } else {
                Text("Seleziona un cliente")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.title2)
            }
            
            Spacer()
        }
        .padding(30)
        .sheet(isPresented: $showAssignWorkout) {
                if let c = selectedCustomer {
                    AssignWorkoutSheet(
                        customer: c,
                        onAssigned: {
                            loadAssignedWorkouts(for: c)
                        }
                    )
                }
            }
    }
    
    func dashboardButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.15))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

}

struct AssignWorkoutSheet: View {
    let customer: Customer
    let onAssigned: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var workouts: [Workout] = []
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Text("Assegna Workout a \(customer.name)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(workouts) { workout in
                            WorkoutRow(workout: workout)
                                .onTapGesture {
                                    assign(workout)
                                }
                        }
                    }
                }

                Spacer()
            }
            .padding(30)
        }
        .task { loadWorkouts() }
    }
    
    private func loadWorkouts() {
        workouts = WorkoutLocalService.shared.getAll()
    }
    
    private func assign(_ workout: Workout) {
        AssignedWorkoutLocalStore.shared.assign(
            workoutId: workout.id,
            to: customer.id
        )
        
        onAssigned()   // aggiorna la colonna 3
        dismiss()
    }
}


extension CustomersDashboardView {
    var workoutList: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("Workout Assegnati")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.horizontal)

            if let _ = selectedCustomer {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(assignedWorkouts) { workout in
                            WorkoutRow(workout: workout)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            } else {
                Text("Seleziona un cliente per vedere i workout")
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
            }
        }
    }
}

struct WorkoutRow: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.name)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text("\(workout.planIds.count) piani inclusi")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }
}

extension CustomersDashboardView {
    func loadCustomers() {
        // TODO: API NestJS GET /customers
        customers = CustomerLocalService.shared.getAll()
    }
    
    func loadAssignedWorkouts(for customer: Customer) {
        let ids = AssignedWorkoutLocalStore.shared.getAssignedWorkouts(for: customer.id)
        assignedWorkouts = WorkoutLocalService.shared.getAll().filter { ids.contains($0.id) }
    }
}
