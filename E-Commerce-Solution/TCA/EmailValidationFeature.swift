//
//  EmailValidationFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
import Foundation
import ValidationKit

@Reducer
struct EmailValidationFeature {
  @ObservableState
  struct State: Equatable {
    var emailText = ""
    var errorMessage: String?
    var validatedEmailResult: Result<EmailAddress, Validator.EmailValidationError>?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case emailTextChanged(String)
    case validateEmail
  }

  @Dependency(\.continuousClock) var clock
  private enum CancelID { case emailValidation }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding: return .none

      case let .emailTextChanged(text):
        state.emailText = text.lowercased()

        // Debounce validation - wait 0.3 seconds after user stops typing
        return .run { send in
          try await clock.sleep(for: .milliseconds(300))
          await send(.validateEmail)
        }
        .cancellable(id: CancelID.emailValidation)

      case .validateEmail: return validateEmailEffect(state: &state)
      }
    }
  }

  private func validateEmailEffect(state: inout State) -> Effect<Action> {
    // Skip validation for empty text (don't show error immediately)
    guard !state.emailText.isEmpty else {
      state.errorMessage = nil
      state.validatedEmailResult = .failure(.empty)
      return .none
    }

    do {
      let validatedEmail = try EmailAddress(state.emailText)
      state.errorMessage = nil
      state.validatedEmailResult = .success(validatedEmail)
    } catch {
      // Email is invalid
      state.errorMessage = emailErrorMessage(for: error)
      state.validatedEmailResult = .failure(error)
    }
    return .none
  }

  private func emailErrorMessage(for error: Validator.EmailValidationError) -> String {
    switch error {
    case .empty: "Email address is empty".localize()
    case .invalidEmailAddress: "Invalid email address".localize()
    }
  }
}
