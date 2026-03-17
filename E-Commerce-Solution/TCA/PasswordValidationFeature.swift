//
//  PasswordValidationFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
import Foundation
import ValidationKit

@Reducer
struct PasswordValidationFeature : Sendable{
  @ObservableState
  struct State: Equatable {
    public var passwordText = ""
    public var isPasswordVisible = false
    public var errorMessage: String?
    public var validatedPasswordResult: Result<DataModels.Password, Validator.PasswordValidationError>?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case passwordTextChanged(String)
    case validatePassword
    case togglePasswordVisibility
  }

  @Dependency(\.continuousClock) var clock
  private enum CancelID { case passwordValidation }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case let .passwordTextChanged(text):
        state.passwordText = text

        // Debounce validation - wait 0.3 seconds after user stops typing
        return .run { send in
          try await clock.sleep(for: .milliseconds(300))
          await send(.validatePassword)
        }
        .cancellable(id: CancelID.passwordValidation)

      case .validatePassword:
        return validatePasswordEffect(state: &state)

      case .togglePasswordVisibility:
        state.isPasswordVisible.toggle()
        return .none
      }
    }
  }

  private func validatePasswordEffect(state: inout State) -> Effect<Action> {
    // Skip validation for empty text (don't show error immediately)
    guard !state.passwordText.isEmpty else {
      state.errorMessage = nil
      state.validatedPasswordResult = nil
      return .none
    }

    do {
      let validatedPassword = try DataModels.Password(state.passwordText)
      state.errorMessage = nil
      state.validatedPasswordResult = .success(validatedPassword)
    } catch {
      state.errorMessage = passwordErrorMessage(for: error)
      state.validatedPasswordResult = .failure(error)
    }
    return .none
  }

  private func passwordErrorMessage(for error: Validator.PasswordValidationError) -> String {
    switch error {
    case let .invalidPassword(requirements):
      requirements.description.localize()
    }
  }
}
