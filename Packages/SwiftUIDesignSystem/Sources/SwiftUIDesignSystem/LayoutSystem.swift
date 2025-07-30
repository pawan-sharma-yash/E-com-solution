import SwiftUI

// MARK: - Breakpoints
enum ScreenSize {
    case compact    // < 428pt
    case regular    // 428pt - 768pt
    case large      // 768pt - 1024pt
    case extraLarge // > 1024pt
    
    static func current(for width: CGFloat) -> ScreenSize {
        switch width {
        case ..<428:
            return .compact
        case 428..<768:
            return .regular
        case 768..<1024:
            return .large
        default:
            return .extraLarge
        }
    }
}

// MARK: - Container Types
enum ContainerType {
    case fluid
    case fixed
    case compact
    
    func maxWidth(for screenSize: ScreenSize) -> CGFloat? {
        switch self {
        case .fluid:
            return nil
        case .fixed:
            return 1200
        case .compact:
            return 600
        }
    }
    
    func padding(for screenSize: ScreenSize) -> CGFloat {
        switch screenSize {
        case .compact:
            return Spacing.medium
        case .regular, .large, .extraLarge:
            return Spacing.large
        }
    }
}

// MARK: - Grid System
struct GridConfiguration {
    let columns: Int
    let gutter: CGFloat
    
    static func configuration(for screenSize: ScreenSize) -> GridConfiguration {
        switch screenSize {
        case .compact:
            return GridConfiguration(columns: 4, gutter: Spacing.small)
        case .regular:
            return GridConfiguration(columns: 8, gutter: Spacing.medium)
        case .large, .extraLarge:
            return GridConfiguration(columns: 12, gutter: Spacing.medium)
        }
    }
}

// MARK: - Container View
struct Container<Content: View>: View {
    let type: ContainerType
    let content: Content
    
    init(_ type: ContainerType = .fluid, @ViewBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = ScreenSize.current(for: geometry.size.width)
            let maxWidth = type.maxWidth(for: screenSize)
            let padding = type.padding(for: screenSize)
            
            HStack {
                if maxWidth != nil {
                    Spacer()
                }
                
                content
                    .frame(maxWidth: maxWidth)
                    .padding(.horizontal, padding)
                
                if maxWidth != nil {
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Grid View
struct Grid<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = ScreenSize.current(for: geometry.size.width)
            let config = GridConfiguration.configuration(for: screenSize)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: config.gutter), count: config.columns),
                spacing: config.gutter
            ) {
                content
            }
        }
    }
}

// MARK: - Responsive Modifiers
extension View {
    func responsive<T>(_ compact: T, _ regular: T, _ large: T, _ extraLarge: T, keyPath: WritableKeyPath<Self, T>) -> some View {
        GeometryReader { geometry in
            let screenSize = ScreenSize.current(for: geometry.size.width)
            let value: T
            
            switch screenSize {
            case .compact:
                value = compact
            case .regular:
                value = regular
            case .large:
                value = large
            case .extraLarge:
                value = extraLarge
            }
            
            var view = self
            view[keyPath: keyPath] = value
            return view
        }
    }
}

