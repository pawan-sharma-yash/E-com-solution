import Combine
import DataModels
@testable import E_Commerce_Solution
import ComposableArchitecture
import Foundation
import Testing
import ValidationKit

@Suite("Password Validation Feature Tests")
struct PasswordValidationFeatureTests {
  private let clock = TestClock()
  private let delayThreshold = 300

  @Test("Initial state has correct default values")
  func testInitialState() async {
    let state = PasswordValidationFeature.State()

    #expect(state.passwordText == "")
    #expect(state.errorMessage == nil)
    #expect(state.validatedPasswordResult == nil)
  }

  @Test("Password text changed updates state with empty password")
  func testPasswordTextChangedEmpty() async {
    let store = await TestStore(initialState: PasswordValidationFeature.State()) {
      PasswordValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.passwordTextChanged(""))
    await clock.advance(by: .milliseconds(delayThreshold))
    await store.receive(\.validatePassword)
  }

  @Test("Password text changed updates state with invalid password")
  func testPasswordTextChangedInvalid() async {
    let store = await TestStore(initialState: PasswordValidationFeature.State()) {
      PasswordValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.passwordTextChanged("Abc@xyzxyz")) {
      $0.passwordText = "Abc@xyzxyz"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validatePassword) {
      $0.errorMessage = "[ValidationKit.Validator.PasswordValidationRequirement.digits(1)]"
      $0.validatedPasswordResult = .failure(.invalidPassword([
        .digits(1)
      ]))
    }
  }

  @Test("Password text changed updates state with valid password")
  func testPasswordTextChangedValid() async {
    let store = await TestStore(initialState: PasswordValidationFeature.State()) {
      PasswordValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.passwordTextChanged("1Abc@xyz.com")) {
      $0.passwordText = "1Abc@xyz.com"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validatePassword) {
      $0.errorMessage = nil
      $0.validatedPasswordResult = .success(try! Password("1Abc@xyz.com"))
    }
  }
}
