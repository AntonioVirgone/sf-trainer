//
//  SFTextField.swift
//  SFTrainer
//
//  Created by Antonio Virgone on 03/12/25.
//

import Foundation
import SwiftUI

// MARK: - Custom Text Input Field
struct SFTextField: View {
    var placeholder: String
    var font: Font = .title2
    var icon: String? = nil
    @Binding var text: String
    var isSecure: Bool = false
    var foregroundColor: Color = .white
    var backgroundColor: Color = .white
    var textInputAutoCapitalize: TextInputAutocapitalization = .never
    var keyboardType: UIKeyboardType = .default

    @ViewBuilder
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(foregroundColor.opacity(0.7))
            }

            if isSecure {
                SecureField(
                    placeholder,
                    text: $text
                )
                .font(font)
                .foregroundColor(.white)
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .font(font)
                        .foregroundColor(foregroundColor.opacity(0.5))
                )
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(textInputAutoCapitalize)
            }
        }
        .padding()
        .background(backgroundColor.opacity(0.15))
        .cornerRadius(10)
    }
}
