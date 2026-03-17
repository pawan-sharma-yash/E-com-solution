// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

/// A utility for validating common user input types like names, emails, and passwords.
///
/// `Validator` provides static methods and predefined validation rules for common
/// validation scenarios in user-facing applications. It includes validation for:
///
/// - Names: Validates proper name formatting with configurable length requirements
/// - Emails: Validates email addresses according to RFC 5322 standards
/// - Passwords: Validates passwords against customizable security requirements
///
/// ## Example Usage
///
/// ```swift
/// // Validate a name
/// let nameResult = Validator.validate(name: "John")
///
/// // Validate an email
/// let emailResult = Validator.validate(email: "user@example.com")
///
/// // Validate a password with default requirements
/// let passwordResult = Validator.validate(password: "SecureP@ss123")
///
/// // Validate a password with custom requirements
/// let customResult = Validator.validate(
///     password: "pass123",
///     against: [.minLength(6), .digits(1)]
/// )
/// ```
public enum Validator {
  /// Regular expression pattern for validating names.
  ///
  /// This pattern allows names consisting of 2-50 alphabetic characters (A-Z, a-z).
  /// - Note: Consider making this configurable for applications with different name requirements.
  static let nameRegex = "^[A-Za-z]{2,50}$"

  /// Regular expression pattern for validating email addresses according to RFC 5322.
  ///
  /// This comprehensive pattern validates email addresses following the full RFC 5322 specification,
  /// including support for special characters, IP addresses, and quoted strings.
  static let emailRegex = """
  ^(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$
  """

  /// Default set of special characters used for password validation.
  ///
  /// These characters are considered "special" when validating the `.specialCharacters`
  /// requirement in password validation.
  public static let defaultSpecialCharacters = "!@#$%^&*()_+-=[]{}|;:,.<>?"

  /// Default set of password validation requirements.
  ///
  /// This provides a reasonable baseline for secure passwords in most applications:
  /// - Minimum length of 8 characters
  /// - Maximum length of 64 characters
  /// - At least 1 uppercase letter
  /// - At least 1 lowercase letter
  /// - At least 1 digit
  /// - At least 1 special character
  /// - No spaces allowed
  public static var defaultPasswordRequirements: Set<PasswordValidationRequirement> {
    [
      .minLength(8),
      .maxLength(64),
      .uppercaseLetters(1),
      .lowercaseLetters(1),
      .digits(1),
      .specialCharacters(1),
      .noSpaces,
    ]
  }

  /// Represents the error in a name validation operation.
  ///
  /// This enum provides detailed information about why a name validation failed.
  public enum NameValidationError: Error {
    /// The name is shorter than the minimum required length.
    /// - Parameter minimum: The minimum required length.
    case tooShort(minimum: UInt)

    /// The name exceeds the maximum allowed length.
    /// - Parameter maximum: The maximum allowed length.
    case tooLong(maximum: UInt)

    /// The name contains characters that don't match the allowed pattern.
    case invalidCharacters
  }

  /// Represents the error in an email validation operation.
  ///
  /// This enum provides information about why an email validation failed.
  public enum EmailValidationError: Error {
    /// The email string is empty after trimming whitespace.
    case empty

    /// The email string does not conform to a valid email address format.
    case invalidEmailAddress
  }

  /// Defines requirements that can be used to validate passwords.
  ///
  /// These requirements can be combined in a set to create custom
  /// password validation rules.
  public enum PasswordValidationRequirement: Hashable, Sendable {
    /// Requires a minimum password length.
    /// - Parameter UInt: The minimum number of characters required.
    case minLength(UInt)

    /// Enforces a maximum password length.
    /// - Parameter UInt: The maximum number of characters allowed.
    case maxLength(UInt)

    /// Requires a minimum number of uppercase letters.
    /// - Parameter UInt: The minimum number of uppercase letters required.
    case uppercaseLetters(UInt)

    /// Requires a minimum number of lowercase letters.
    /// - Parameter UInt: The minimum number of lowercase letters required.
    case lowercaseLetters(UInt)

    /// Requires a minimum number of digits.
    /// - Parameter UInt: The minimum number of digits required.
    case digits(UInt)

    /// Requires a minimum number of special characters.
    /// - Parameter UInt: The minimum number of special characters required.
    case specialCharacters(UInt)

    /// Prohibits spaces in the password.
    case noSpaces

    /// Validates the password against a custom regular expression.
    /// - Parameter String: The regular expression pattern to match.
    case regex(String)

      public var priority: Int {
          switch self {
          case .minLength:         1
          case .digits:            2
          case .maxLength:         3
          case .uppercaseLetters:  4
          case .lowercaseLetters:  5
          case .specialCharacters: 6
          case .noSpaces:          7
          case .regex:             8
          }
      }
  }

  /// Represents the result of a password validation operation.
  ///
  /// This enum provides detailed information about why a password validation failed.
  public enum PasswordValidationError: Error {
    /// The password failed to meet one or more requirements.
    /// - Parameter [PasswordValidationRequirement]: The specific requirements that weren't met.
    case invalidPassword([PasswordValidationRequirement])
  }

  /// Represents the result of mobile number validation.
  ///
  /// This enumeration provides a clear indication of whether a mobile number
  /// passed validation according to international phone number standards.
  ///
  /// ## Overview
  ///
  /// The validation result helps determine the next steps in your application flow.
  /// You can use pattern matching or switch statements to handle different validation outcomes.
  ///
  /// ## Usage
  ///
  /// ```swift
  /// let result = Validator.validate(mobileNumber: phoneNumber)
  ///
  /// switch result {
  /// case .valid:
  ///     // Proceed with phone number processing
  ///     submitForm()
  /// }
  /// ```
  ///
  /// ## Topics
  ///
  /// ### Cases
  ///
  /// - ``invalidMobileNumber``
  ///
  /// - ``Validator/validate(mobileNumber:)``
  public enum MobileNumberValidationError: Error {
    case invalidMobileNumber
  }
}
