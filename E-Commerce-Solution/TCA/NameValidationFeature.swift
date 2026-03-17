//
//  NameValidationFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
import Foundation
import ValidationKit

@Reducer
struct NameValidationFeature {
  @ObservableState
  struct State: Equatable {
    var nameText = ""
    var errorMessage: String?
    var validatedNameResult: Result<DataModels.Name, Validator.NameValidationError>?
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case nameTextChanged(String)
    case validateName
  }

  @Dependency(\.continuousClock) var clock
  private enum CancelID { case nameValidation }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case let .nameTextChanged(text):
        state.nameText = text

        // Debounce validation - wait 0.3 seconds after user stops typing
        return .run { send in
          try await clock.sleep(for: .milliseconds(300))
          await send(.validateName)
        }
        .cancellable(id: CancelID.nameValidation)

      case .validateName:
        return validateNameEffect(state: &state)
      }
    }
  }

  private func validateNameEffect(state: inout State) -> Effect<Action> {
    // Skip validation for empty text (don't show error immediately)
    guard !state.nameText.isEmpty else {
      state.errorMessage = nil
      state.validatedNameResult = nil
      return .none
    }

    do {
      let validatedName = try DataModels.Name(state.nameText)
      state.errorMessage = nil
      state.validatedNameResult = .success(validatedName)
    } catch {
      // Email is invalid
      state.errorMessage = nameErrorMessage(for: error)
      state.validatedNameResult = .failure(error)
    }
    return .none
  }

  private func nameErrorMessage(for error: Validator.NameValidationError) -> String {
    switch error {
    case .invalidCharacters: "Name contains invalid characters".localize()
    case let .tooLong(maximum: length): "Name should not be longer than \(length) characters".localize()
    case let .tooShort(minimum: length): "Name should be at least \(length) characters long".localize()
    }
  }
}
