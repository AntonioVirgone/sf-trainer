//
//  TestView.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 30/11/25.
//

import Foundation
import SwiftUI

struct TestView : View {
    var body: some View {
        NavigationStack {
            doubleColumn
        }
    }
    
    // MARK: - Vista principale con due colonne + bottone fisso
    private var doubleColumn: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                
                HStack(alignment: .top, spacing: 24) {
                    VStack {
                        Text("Test 1")
                    }
                    .frame(width: geo.size.width * 0.7)
                    
                    VStack {
                        Text("Test 2")
                    }
                    .frame(width: geo.size.width * 0.7)
                        .padding(.trailing, 24)
                        .frame(width: geo.size.width * 0.3)
                }
                .padding()
                
            }
            .background(backgroundGradient)
            .navigationTitle("Nuovo Plan")
        }
    }
}

#Preview {
    TestView()
}
