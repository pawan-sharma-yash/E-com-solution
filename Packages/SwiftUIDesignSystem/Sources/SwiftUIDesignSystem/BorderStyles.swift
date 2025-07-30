import SwiftUI

enum BorderRadius {
    static let none: CGFloat = 0
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    static let extraLarge: CGFloat = 16
    static let round: CGFloat = 50 // Will be applied as percentage
}

enum BorderWidth {
    static let none: CGFloat = 0
    static let thin: CGFloat = 1
    static let medium: CGFloat = 2
    static let thick: CGFloat = 4
}

extension Color {
    // Border Colors
    static let borderDefault = Color("BorderDefault")
    static let borderSubtle = Color("BorderSubtle")
    static let borderStrong = Color("BorderStrong")
    static let borderFocus = Color("BorderFocus")
    static let borderError = Color("BorderError")
    static let borderSuccess = Color("BorderSuccess")
    static let borderWarning = Color("BorderWarning")
}

struct BorderStyle {
    let width: CGFloat
    let color: Color
    let radius: CGFloat
    
    static let none = BorderStyle(width: BorderWidth.none, color: .clear, radius: BorderRadius.none)
    static let `default` = BorderStyle(width: BorderWidth.thin, color: .borderDefault, radius: BorderRadius.medium)
    static let subtle = BorderStyle(width: BorderWidth.thin, color: .borderSubtle, radius: BorderRadius.medium)
    static let strong = BorderStyle(width: BorderWidth.medium, color: .borderStrong, radius: BorderRadius.medium)
    static let focus = BorderStyle(width: BorderWidth.medium, color: .borderFocus, radius: BorderRadius.medium)
    static let error = BorderStyle(width: BorderWidth.medium, color: .borderError, radius: BorderRadius.medium)
    static let success = BorderStyle(width: BorderWidth.medium, color: .borderSuccess, radius: BorderRadius.medium)
    static let warning = BorderStyle(width: BorderWidth.medium, color: .borderWarning, radius: BorderRadius.medium)
}

struct BorderModifier: ViewModifier {
    let style: BorderStyle
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: style.radius)
                    .stroke(style.color, lineWidth: style.width)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.radius))
    }
}

extension View {
    func border(_ style: BorderStyle) -> some View {
        modifier(BorderModifier(style: style))
    }
    
    func cornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

