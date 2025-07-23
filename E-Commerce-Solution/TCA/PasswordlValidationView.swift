//
//  email_validation_view.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import SwiftUI

struct PasswordValidationView: View {
    let store: StoreOf<PasswordValidationFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                // Password Field
                CustomSecureField(
                    title: "Password",
                    text: viewStore.binding(
                        get: \.passwordText,
                        send: PasswordValidationFeature.Action.passwordTextChanged
                    ),
                    placeholder: "Enter your password",
                    isVisible: viewStore.binding(
                        get: \.isPasswordVisible,
                        send: PasswordValidationFeature.Action.togglePasswordVisibility
                    ),
                    hasError: viewStore.errorMessage != nil
                )

                // Error Message
                if let validationError = viewStore.errorMessage {
                    ErrorMessageView(message: validationError)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PasswordValidationView(
        store: Store(initialState: PasswordValidationFeature.State()) {
            PasswordValidationFeature()
        }
    )
}
