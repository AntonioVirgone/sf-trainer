//
//  CustomerDashboardView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 27/11/25.
//

import Foundation
import SwiftUI

struct CustomerDashboardView: View {
    @State private var customers: [Customer] = []
    @State private var selectedCustomer: Customer?
    
    var body: some View {
        NavigationSplitView {
            CustomerSidebarView(customers: customers, selectedCustomer: $selectedCustomer)
        } detail: {
            if let customer = selectedCustomer {
                CustomerDetailPanel(customer: customer)
                    .background(backgroundGradient)     // 🔥 Sidebar con background
            } else {
                EmptyDetailPlaceholder()
                    .background(backgroundGradient)     // 🔥 Sidebar con background
            }
        }
        .background(backgroundGradient)        // 🔥 Funziona
        .task { await loadCustomers() }
    }
    
    private func loadCustomers() async {
        // QUI chiami le tue API
        // customers = try await CustomerApiService.shared.getAll()
        
        // mock temporaneo
        customers = [
            Customer(id: "1", name: "Marco Ferri", email: ""),
            Customer(id: "2", name: "Giulia Bianchi", email: ""),
            Customer(id: "3", name: "Luca Verdi", email: ""),
            Customer(id: "4", name: "Anna Rossi", email: "")
        ]
    }
}

struct CustomerSidebarView: View {
    let customers: [Customer]
    @Binding var selectedCustomer: Customer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Clients")
                .font(.title.bold())
                .padding(.top, 40)
                .padding(.horizontal)
                .foregroundColor(.white)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(customers) { customer in
                        Button {
                            selectedCustomer = customer
                        } label: {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Text(initials(customer.name))
                                            .font(.headline.bold())
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(customer.name)
                                        .foregroundColor(.white)
                                        .font(.body)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(red: 0.10, green: 0.12, blue: 0.15)) // dark sidebar
        .ignoresSafeArea()
    }
    
    private func initials(_ name: String) -> String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}

struct CustomerDetailPanel: View {
    let customer: Customer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(customer.name)
                            .font(.largeTitle.bold())
                        Text("Workout & History")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                    }
                }
                
                Divider()
                
                // Section TODAY
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today")
                        .font(.title3.bold())
                    
                    TaskRow(title: "Panca piana 4x8", completed: true)
                    TaskRow(title: "Squat 3x10", completed: false)
                    TaskRow(title: "Stretching", completed: false)
                }
                
                Divider()
                
                // Section HISTORY
                VStack(alignment: .leading, spacing: 12) {
                    Text("History")
                        .font(.title3.bold())
                    
                    HistoryRow(date: "21 Nov 2025", notes: "Workout completo + ottima esecuzione")
                    HistoryRow(date: "19 Nov 2025", notes: "Leggero calo di forza")
                }
                
                Spacer()
            }
            .padding(32)
        }
    }
}

struct TaskRow: View {
    let title: String
    let completed: Bool
    
    var body: some View {
        HStack {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(completed ? .pink : .gray)
            Text(title)
            Spacer()
            if completed { Text("Complete").foregroundColor(.secondary) }
        }
        .padding(.vertical, 4)
    }
}

struct HistoryRow: View {
    let date: String
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date).font(.subheadline.bold())
            Text(notes).font(.body).foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyDetailPlaceholder: View {
    var body: some View {
        VStack {
            Text("Select a client")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
