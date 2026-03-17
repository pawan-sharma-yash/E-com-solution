import Combine
import DataModels
@testable import E_Commerce_Solution
import ComposableArchitecture
import Foundation
import Testing
import ValidationKit

@Suite("Name Validation Feature Tests")
struct NameValidationFeatureTests {
  private let clock = TestClock()
  private let delayThreshold = 300

  @Test("Initial state has correct default values")
  func testInitialState() async {
    let state = NameValidationFeature.State()

    #expect(state.nameText == "")
    #expect(state.errorMessage == nil)
    #expect(state.validatedNameResult == nil)
  }

  @Test("Name text changed updates state with empty password")
  func testNameTextChangedEmpty() async {
    let store = await TestStore(initialState: NameValidationFeature.State()) {
      NameValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.nameTextChanged(""))
    await clock.advance(by: .milliseconds(delayThreshold))
    await store.receive(\.validateName)
  }

  @Test("Name text changed updates state with invalid name")
  func testNameTextChangedInvalid() async {
    let store = await TestStore(initialState: NameValidationFeature.State()) {
      NameValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.nameTextChanged("Pa")) {
      $0.nameText = "Pa"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validateName) {
      $0.errorMessage = "Name should be at least 3 characters long"
      $0.validatedNameResult = .failure(.tooShort(minimum: 3))
    }
  }

  @Test("Name text changed updates state with valid name")
  func testNameTextChangedValid() async {
    let store = await TestStore(initialState: NameValidationFeature.State()) {
      NameValidationFeature()
    } withDependencies: { $0.continuousClock = clock }

    await store.send(.nameTextChanged("Pawan")) {
      $0.nameText = "Pawan"
    }

    await clock.advance(by: .milliseconds(delayThreshold))

    await store.receive(\.validateName) {
      $0.errorMessage = nil
      $0.validatedNameResult = .success(try! Name("Pawan"))
    }
  }
}
