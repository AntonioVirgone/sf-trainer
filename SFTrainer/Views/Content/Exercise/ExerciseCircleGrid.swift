//
//  ExerciseCircleGrid.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 28/11/25.
//

import Foundation
import SwiftUI

struct ExerciseCircleGrid: View {
    let exercises: [Exercise]
    @Binding var selectedId: String
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(exercises) { ex in
                ExerciseCardView(exercise: ex, exercises: exercises, width: 70.0, height: 70.0, imageSize: 26.0, selectedId: $selectedId)
            }
        }
    }
}

