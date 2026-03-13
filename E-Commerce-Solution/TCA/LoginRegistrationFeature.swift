//
//  Untitled.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 18/03/26.
//

import ComposableArchitecture

@Reducer
struct LoginRegistrationFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var forgotPasswordPresentation: ForgotPasswordFeature.State?
  }

  enum Action {
    case forgotPasswordButtonTapped
    // 2. Add a 'presentation' action for the child
    case showForgotPassword(PresentationAction<ForgotPasswordFeature.Action>)
    case dismissForgotPassword
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .forgotPasswordButtonTapped:
        // 3. Populate state to trigger presentation
        state.forgotPasswordPresentation = ForgotPasswordFeature.State()
        return .none

      case .dismissForgotPassword:
        state.forgotPasswordPresentation = nil
        return .none

      case .showForgotPassword:
        return .none
      }
    }
    // 4. Integrate the child reducer
    .ifLet(\.$forgotPasswordPresentation, action: \.showForgotPassword) {
      ForgotPasswordFeature()
    }
  }
}
