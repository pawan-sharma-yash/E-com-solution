//
//  LoginRegistrationView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import DataModels
import SwiftUI
import ValidationKit
import ComposableArchitecture

// MARK: - Main Login View

struct LoginRegistrationView: View {
    @StateObject private var viewModel = LoginRegistrationViewModel()
    private let emailStore = Store(initialState: EmailValidationFeature.State()) {
        EmailValidationFeature()
    }
    private let passwordStore = Store(initialState: PasswordValidationFeature.State()) {
        PasswordValidationFeature()
    }
    private let nameStore = Store(initialState: NameValidationFeature.State()) {
        NameValidationFeature()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                LoginHeaderView()

                // Toggle Section
                LoginToggleView(selectedMode: $viewModel.selectedMode)

                VStack(spacing: 20) {
                    // Email Field
                    EmailValidationView(store: emailStore)
                    PasswordValidationView(store: passwordStore)

                    if self.viewModel.selectedMode == .new {
                        NameValidationView(store: nameStore)
                    }

                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(
                            "Forgot Password?",
                            action: {}
                        )
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    }

                    if self.viewModel.selectedMode == .new {
                        PrimaryButton(
                            title: "Sign Up",
                            isLoading: viewModel.isLoading,
                            action: {
                                guard
                                    let email = try? emailStore.validatedEmailResult?.get(),
                                    let password = try? passwordStore.validatedPasswordResult?.get(),
                                    let name = try? nameStore.validatedNameResult?.get()
                                else { return }
                                viewModel.signup(email: email, password: password, name: name)
                            }
                        )
                        .alert(isPresented: Binding(
                            get: {
                                guard let _ = viewModel.authenticationService.errorMessage else { return false }
                                return true
                            },
                            set: { value in
                                viewModel.authenticationService.errorMessage = value
                                    ? viewModel.authenticationService.errorMessage
                                    : nil
                            }
                        )) {
                            Alert(
                                title: Text("Attention"),
                                message: Text(viewModel.authenticationService.errorMessage ?? "Unknown error!"),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }

                    if self.viewModel.selectedMode == .existing {
                        // Sign In Button
                        PrimaryButton(
                            title: "Sign In",
                            isLoading: viewModel.isLoading,
                            action: {
                                guard
                                    let email = try? emailStore.validatedEmailResult?.get(),
                                    let password = try? passwordStore.validatedPasswordResult?.get()
                                else { return }
                                viewModel.signIn(email: email, password: password)
                            }
                        )
                        .alert(isPresented: Binding(
                            get: {
                                guard let _ = viewModel.authenticationService.errorMessage else { return false }
                                return true
                            },
                            set: { value in
                                viewModel.authenticationService.errorMessage = value
                                    ? viewModel.authenticationService.errorMessage
                                    : nil
                            }
                        )) {
                            Alert(
                                title: Text("Attention"),
                                message: Text(viewModel.authenticationService.errorMessage ?? "Unknown error!"),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }
                }

                // Social Login Section
                SocialLoginView(
                    onGoogleLogin: viewModel.signInWithGoogle,
                    onAppleLogin: viewModel.signInWithApple
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

#Preview {
    LoginRegistrationView()
}

#if DEBUG
    fileprivate let rainbowDebugColors: [Color] = [
        .purple, .blue, .green,
        .yellow, .orange, .red,
        .mint, .cyan, .pink, .teal,
    ]

    extension View {
        func rainbowDebug() -> some View {
            background(rainbowDebugColors.randomElement()!)
        }
    }
#else
    extension View {
        func rainbowDebug() -> some View {
            self
        }
    }
#endif
