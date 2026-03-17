import Combine
import DataModels
@testable import E_Commerce_Solution
import ComposableArchitecture
import Foundation
import Testing
import ValidationKit

@Suite("Email Validation Feature Tests")
struct EmailValidationFeatureTests {
  private let clock = TestClock()
  private let delayThreshold = 300

  @Test("Initial state has correct default values")
  func testInitialState() async {
    let state = EmailValidationFeature.State()

    #expect(state.emailText == "")
    #expect(state.errorMessage == nil)
    #expect(state.validatedEmailResult == nil)
  }

  @Test("Email text changed updates state with empty email")
  func testEmailTextChangedEmpty() async {
    let store = await TestStore(initialState: EmailValidationFeature.State()) {
      EmailValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.emailTextChanged(""))
    await clock.advance(by: .milliseconds(delayThreshold))
    await store.receive(\.validateEmail) {
      $0.errorMessage = nil
      $0.validatedEmailResult = .failure(.empty)
    }
  }

  @Test("Email text missing domain name")
  func testEmailTextMissingDomainName() async {
    let store = await TestStore(initialState: EmailValidationFeature.State()) {
      EmailValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.emailTextChanged("abc@xyz")) {
      $0.emailText = "abc@xyz"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validateEmail) {
      $0.errorMessage = "Invalid email address".localize()
      $0.validatedEmailResult = .failure(.invalidEmailAddress)
    }
  }

  @Test("Email text missing @ sign")
  func testEmailTextMissingAtSign() async {
    let store = await TestStore(initialState: EmailValidationFeature.State()) {
      EmailValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.emailTextChanged("abcxyz.com")) {
      $0.emailText = "abcxyz.com"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validateEmail) {
      $0.errorMessage = "Invalid email address".localize()
      $0.validatedEmailResult = .failure(.invalidEmailAddress)
    }
  }

  @Test("Email text changed updates state with valid email")
  func testEmailTextChangedValid() async {
    let store = await TestStore(initialState: EmailValidationFeature.State()) {
      EmailValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.emailTextChanged("abc@xyz.com")) {
      $0.emailText = "abc@xyz.com"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validateEmail) {
      $0.errorMessage = nil
      $0.validatedEmailResult = .success(try! EmailAddress("abc@xyz.com"))
    }
  }
}
