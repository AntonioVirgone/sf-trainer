//
//  PlanCardView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI

struct PlanCard: View {
    let plan: Plan
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(plan.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Giorni: \(plan.name)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.white.opacity(0.2), lineWidth: 2)
        )
    }
}

