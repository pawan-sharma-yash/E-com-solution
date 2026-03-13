//
//  FirebaseAuthFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
import FirebaseAuth
import Foundation
import ValidationKit

@Reducer
struct FirebaseAuthFeature {
  @ObservableState
  struct State: Equatable {
    fileprivate(set) var isLoading = false
    fileprivate(set) var currentUser: DataModels.AuthUser?
    fileprivate(set) var errorMessage: String?
    fileprivate(set) var showErrorAlert = false
    fileprivate(set) var selectedMode = UserAuthMode.existing

    // Computed properties
    var isSignedIn: Bool { currentUser != nil }
  }

  enum Action {
    case signIn(email: EmailAddress, password: Password)
    case signUp(email: EmailAddress, password: Password, name: Name)
    case signOut
    case authStateChanged(AuthUser?)
    case authResponse(Result<AuthUser, AuthError>)
    case dismissErrorAlert
    case startListeningToAuthState
    case stopListeningToAuthState
    case switchAuthMode
  }

  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  private enum CancelID { case authStateListener }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .switchAuthMode:
        state.selectedMode = if state.selectedMode == .new { .existing } else { .new }
        return .none

      case let .signIn(email, password):
        state.isLoading = true

        return .run { send in
          let result = await firebaseAuthClient.signIn(email, password)
          await send(.authResponse(result))
        }

      case let .signUp(email, password, name):
        state.isLoading = true

        return .run { send in
          let result = await firebaseAuthClient.signUp(email, password, name)
          await send(.authResponse(result))
        }

      case .signOut:
        state.isLoading = true

        return .run { send in
          let signOutResult = await firebaseAuthClient.signOut()
          switch signOutResult {
          case let .failure(err): await send(.authResponse(.failure(err)))
          case .success: await send(.authStateChanged(nil))
          }
        }

      case let .authStateChanged(user):
        state.currentUser = user
        state.isLoading = false
        return .none

      case let .authResponse(result):
        state.isLoading = false

        switch result {
        case let .success(user):
          state.currentUser = user
          state.errorMessage = nil

        case let .failure(error):
          state.errorMessage = error.localizedDescription
          state.showErrorAlert = true
        }

        return .none

      case .dismissErrorAlert:
        state.showErrorAlert = false
        state.errorMessage = nil
        return .none

      case .startListeningToAuthState:
        return .run { send in
          for await user in firebaseAuthClient.authStateStream() {
            await send(.authStateChanged(user))
          }
        }
        .cancellable(id: CancelID.authStateListener)

      case .stopListeningToAuthState:
        return .cancel(id: CancelID.authStateListener)
      }
    }
  }
}
