//
//  CustomersAreaView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation
import SwiftUI

struct CustomersAreaView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Clienti")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    Text("Crea clienti, assegna workout e controlla le schede.")
                        .foregroundColor(.white.opacity(0.7))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        
                        NavigationLink {
                            CreateCustomerView()
                        } label: {
                            FeatureCard(
                                title: "Nuovo cliente",
                                subtitle: "Registra un nuovo atleta",
                                systemImage: "person.badge.plus"
                            )
                        }
                                                
                        NavigationLink {
                            CustomersDashboardView()
                        } label: {
                            FeatureCard(
                                title: "Dashboard",
                                subtitle: "Vedi scheda e history",
                                systemImage: "rectangle.grid.1x2"
                            )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(backgroundGradient)        // 🔥 Funziona
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FeatureCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        ZStack {
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
            
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(.green)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                Spacer()
            }
            .padding()
        }
        .frame(height: 140)
    }
}
