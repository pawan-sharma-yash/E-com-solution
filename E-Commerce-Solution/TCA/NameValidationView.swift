//
//  email_validation_view.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import SwiftUI

struct NameValidationView: View {
    let store: StoreOf<NameValidationFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                // Name field
                CustomTextField(
                    title: "Name",
                    text: viewStore.binding(
                        get: \.nameText,
                        send: NameValidationFeature.Action.nameTextChanged
                    ),
                    placeholder: "Enter your full name",
                    keyboardType: .emailAddress,
                    autoCorrection: false,
                    autoCapitalization: .never,
                    hasError: viewStore.errorMessage != nil
                ) {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.gray)
                }

                if let validationError = viewStore.errorMessage {
                    ErrorMessageView(message: validationError)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NameValidationView(
        store: Store(initialState: NameValidationFeature.State()) {
            NameValidationFeature()
        }
    )
}
