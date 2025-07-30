import SwiftUI

extension Font {
    static func custom(_ style: TextStyle) -> Font {
        switch style {
        case .displayLarge:
            return .system(size: 48, weight: .bold)
        case .displayMedium:
            return .system(size: 36, weight: .bold)
        case .headline:
            return .system(size: 24, weight: .semibold)
        case .title1:
            return .system(size: 20, weight: .semibold)
        case .title2:
            return .system(size: 18, weight: .medium)
        case .body:
            return .system(size: 17, weight: .regular)
        case .callout:
            return .system(size: 16, weight: .regular)
        case .subhead:
            return .system(size: 15, weight: .regular)
        case .footnote:
            return .system(size: 13, weight: .regular)
        case .caption1:
            return .system(size: 12, weight: .regular)
        }
    }
}

enum TextStyle {
    case displayLarge
    case displayMedium
    case headline
    case title1
    case title2
    case body
    case callout
    case subhead
    case footnote
    case caption1
}

