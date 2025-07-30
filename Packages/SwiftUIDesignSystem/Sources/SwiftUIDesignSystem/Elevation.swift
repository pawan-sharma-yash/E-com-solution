import SwiftUI

struct ShadowStyle {
    let radius: CGFloat
    let offset: CGSize
    let opacity: Double
}

struct Elevation {
    static let none = ShadowStyle(radius: 0, offset: .zero, opacity: 0)
    static let level1 = ShadowStyle(radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.1)
    static let level2 = ShadowStyle(radius: 4, offset: CGSize(width: 0, height: 2), opacity: 0.15)
    static let level3 = ShadowStyle(radius: 8, offset: CGSize(width: 0, height: 4), opacity: 0.2)
    static let level4 = ShadowStyle(radius: 16, offset: CGSize(width: 0, height: 8), opacity: 0.25)
    static let level5 = ShadowStyle(radius: 24, offset: CGSize(width: 0, height: 12), opacity: 0.3)
}

struct ElevationModifier: ViewModifier {
    let shadowStyle: ShadowStyle
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(shadowStyle.opacity),
                radius: shadowStyle.radius,
                x: shadowStyle.offset.width,
                y: shadowStyle.offset.height
            )
    }
}

extension View {
    func elevation(_ style: ShadowStyle) -> some View {
        modifier(ElevationModifier(shadowStyle: style))
    }
}

