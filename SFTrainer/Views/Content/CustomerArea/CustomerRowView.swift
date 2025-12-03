//
//  CustomerRow.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 01/12/25.
//

import Foundation
import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(customer.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }
}
