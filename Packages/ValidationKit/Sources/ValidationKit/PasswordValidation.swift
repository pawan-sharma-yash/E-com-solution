//
//  File.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//
import Foundation

extension Validator.PasswordValidationError: Mappable {}

extension Validator.PasswordValidationRequirement: Mappable {}

extension Validator.PasswordValidationRequirement: Equatable {
  public static func == (
    lhs: Validator.PasswordValidationRequirement,
    rhs: Validator.PasswordValidationRequirement
  ) -> Bool {
    switch (lhs, rhs) {
    case let (.minLength(length1), .minLength(length2)): length1 == length2
    case let (.maxLength(length1), .maxLength(length2)): length1 == length2
    case let (.uppercaseLetters(count1), .uppercaseLetters(count2)): count1 == count2
    case let (.lowercaseLetters(count1), .lowercaseLetters(count2)): count1 == count2
    case let (.digits(count1), .digits(count2)): count1 == count2
    case let (.specialCharacters(count1), .specialCharacters(count2)): count1 == count2
    case let (.regex(r1), .regex(r2)): r1 == r2
    case (.noSpaces, .noSpaces): true
    default: false
    }
  }
}

extension Validator.PasswordValidationError: Equatable {
  public static func == (
    lhs: Validator.PasswordValidationError,
    rhs: Validator.PasswordValidationError
  ) -> Bool {
    switch (lhs, rhs) {
    case (.invalidPassword, .invalidPassword): true
    default: false
    }
  }
}

public extension Validator {
  /// Validates a password against a set of security requirements.
  ///
  /// This function checks a password string against various security requirements and returns
  /// a result indicating whether the password is valid or, if invalid, which specific requirements failed.
  ///
  /// - Example:
  ///   ```swift
  ///   let result = Validator.validate(
  ///       password: "MyP@ssw0rd",
  ///       against: [.minLength(8), .uppercaseLetters(1), .specialCharacters(1)]
  ///   )
  ///   ```
  ///
  /// - Parameters:
  ///   - password: The password string to validate.
  ///   - requirements: A set of `PasswordValidationRequirement` that the password must meet.
  ///     Defaults to `defaultPasswordRequirements`.
  ///   - specialCharacters: A string containing characters considered "special" for the
  ///     `.specialCharacters` requirement. Defaults to `defaultSpecialCharacters`.
  ///
  /// - Returns: A `PasswordValidationResult` that is either:
  ///   - `.validPassword`: The password meets all specified requirements.
  ///   - `.invalidPassword(failures)`: The password fails one or more requirements, with `failures`
  ///     containing the specific requirements that weren't met.
  static func validate(
    password: String,
    against requirements: Set<PasswordValidationRequirement> = defaultPasswordRequirements,
    specialCharacters: String = defaultSpecialCharacters
  ) -> Result<Void, PasswordValidationError> {
    var failures: [PasswordValidationRequirement] = []

    for requirement in requirements {
      switch requirement {
      case let .minLength(count):
        if password.count < count {
          failures.append(requirement)
        }
      case let .maxLength(count):
        if password.count > count {
          failures.append(requirement)
        }
      case let .uppercaseLetters(count):
        if password.unicodeScalars.filter({ CharacterSet.uppercaseLetters.contains($0) }).count < count {
          failures.append(requirement)
        }
      case let .lowercaseLetters(count):
        if password.unicodeScalars.filter({ CharacterSet.lowercaseLetters.contains($0) }).count < count {
          failures.append(requirement)
        }
      case let .digits(count):
        if password.unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) }).count < count {
          failures.append(requirement)
        }
      case let .specialCharacters(count):
        if password.filter({ specialCharacters.contains($0) }).count < count {
          failures.append(requirement)
        }
      case .noSpaces:
        if password.contains(" ") {
          failures.append(requirement)
        }
      case let .regex(passwordValidationRegex):
        let passwordPredicate = NSPredicate(
          format: "SELF MATCHES %@",
          passwordValidationRegex
        )
        if !passwordPredicate.evaluate(with: password) {
          failures.append(requirement)
        }
      }
    }

    return if failures.isEmpty {
      .success(())
    } else {
        .failure(.invalidPassword(failures.sorted(by: { $0.priority < $1.priority })))
    }
  }
}
