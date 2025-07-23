//
//  email_validation_view.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import SwiftUI

struct EmailValidationView: View {
    let store: StoreOf<EmailValidationFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                CustomTextField(
                    title: "Email Address",
                    text: viewStore.binding(
                        get: \.emailText,
                        send: EmailValidationFeature.Action.emailTextChanged
                    ),
                    placeholder: "Enter your email",
                    keyboardType: .emailAddress,
                    autoCorrection: false,
                    autoCapitalization: .never,
                    hasError: viewStore.errorMessage != nil
                ) {
                    Image(systemName: "envelope")
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
    EmailValidationView(
        store: Store(initialState: EmailValidationFeature.State()) {
            EmailValidationFeature()
        }
    )
}
