//
//  LoginRegistrationView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import ComposableArchitecture
import DataModels
import SwiftUI
import UIComponents
import ValidationKit

// MARK: - Main Login View

struct LoginRegistrationView: View {
  private let emailStore = Store(
    initialState: EmailValidationFeature.State()
  ) { EmailValidationFeature() }

  private let passwordStore = Store(
    initialState: PasswordValidationFeature.State()
  ) { PasswordValidationFeature() }

  private let nameStore = Store(
    initialState: NameValidationFeature.State()
  ) { NameValidationFeature() }

  private let firebaseAuthStore: StoreOf<FirebaseAuthFeature> = Store(
    initialState: FirebaseAuthFeature.State()
  ) { FirebaseAuthFeature() }

  @StateObject
  private var loginRegistrationStore: StoreOf<LoginRegistrationFeature> = Store(
    initialState: LoginRegistrationFeature.State()
  ) { LoginRegistrationFeature() }

  var body: some View {
    WithViewStore(firebaseAuthStore, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 32) {
          // Header Section
          LoginHeaderView()

          // Toggle Section
          LoginToggleView(
            selectedMode: viewStore.binding(
              get: \.selectedMode,
              send: .switchAuthMode
            )
          )

          VStack(spacing: 20) {
            // Email Field
            EmailValidationView(store: emailStore)
            PasswordValidationView(store: passwordStore)

            if firebaseAuthStore.selectedMode == .new { NameValidationView(store: nameStore) }

            // Forgot Password Link
            HStack {
              Spacer()
              Button("Forgot Password?") {
                loginRegistrationStore.send(.forgotPasswordButtonTapped)
              }
              .font(.caption)
              .foregroundColor(.blue)
            }

            if firebaseAuthStore.selectedMode == .new {
              PrimaryButton(
                title: "Sign Up",
                isLoading: firebaseAuthStore.isLoading,
                action: {
                  guard
                    let email = try? emailStore.validatedEmailResult?.get(),
                    let password = try? passwordStore.validatedPasswordResult?.get(),
                    let name = try? nameStore.validatedNameResult?.get()
                  else { return }
                  viewStore.send(.signUp(email: email, password: password, name: name))
                }
              )
              .alert(isPresented: viewStore.binding(
                get: \.showErrorAlert,
                send: .dismissErrorAlert
              )) {
                Alert(
                  title: Text("Attention"),
                  message: Text(firebaseAuthStore.errorMessage ?? "Unknown error!"),
                  dismissButton: .default(Text("Ok"))
                )
              }
            }

            if firebaseAuthStore.selectedMode == .existing {
              // Sign In Button
              PrimaryButton(
                title: "Sign In",
                isLoading: firebaseAuthStore.isLoading,
                action: {
                  guard
                    let email = try? emailStore.validatedEmailResult?.get(),
                    let password = try? passwordStore.validatedPasswordResult?.get()
                  else { return }

                  viewStore.send(.signIn(email: email, password: password))
                }
              )
              .alert(isPresented: viewStore.binding(
                get: \.showErrorAlert,
                send: .dismissErrorAlert
              )) {
                Alert(
                  title: Text("Attention"),
                  message: Text(firebaseAuthStore.errorMessage ?? "Unknown error!"),
                  dismissButton: .default(Text("Ok"))
                )
              }
            }
          }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
      }
      .background(Color(.systemBackground))
      .onAppear {
        viewStore.send(.startListeningToAuthState)
      }
      .onDisappear {
        viewStore.send(.stopListeningToAuthState)
      }
      .fullScreenCover(
        store: loginRegistrationStore.scope(
          state: \.$forgotPasswordPresentation,
          action: \.showForgotPassword
        )
      ) { childStore in
        ForgotPasswordView(onDismiss: {
          loginRegistrationStore.send(.dismissForgotPassword)
        })
      }
    }
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
