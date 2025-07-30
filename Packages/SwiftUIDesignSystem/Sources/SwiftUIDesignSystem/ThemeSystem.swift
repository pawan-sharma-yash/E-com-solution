import SwiftUI

// MARK: - Theme Protocol
protocol Theme {
    // Colors
    var background: Color { get }
    var surface: Color { get }
    var primary: Color { get }
    var secondary: Color { get }
    var accent: Color { get }
    
    // Text Colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textTertiary: Color { get }
    var textInverse: Color { get }
    
    // Border Colors
    var borderPrimary: Color { get }
    var borderSecondary: Color { get }
    var borderFocus: Color { get }
    
    // Status Colors
    var success: Color { get }
    var warning: Color { get }
    var error: Color { get }
    var info: Color { get }
    
    // Shadow Colors
    var shadowColor: Color { get }
}

// MARK: - Light Theme
struct LightTheme: Theme {
    let background = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    let surface = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    let secondary = Color(red: 0.35, green: 0.34, blue: 0.84) // #5856D6
    let accent = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    
    let textPrimary = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    let textSecondary = Color(red: 0.24, green: 0.24, blue: 0.26) // #3C3C43
    let textTertiary = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    let textInverse = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    
    let borderPrimary = Color(red: 0.78, green: 0.78, blue: 0.80) // #C7C7CC
    let borderSecondary = Color(red: 0.90, green: 0.90, blue: 0.92) // #E5E5EA
    let borderFocus = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    
    let success = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
    let warning = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    let error = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    let info = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    
    let shadowColor = Color.black.opacity(0.1)
}

// MARK: - Dark Theme
struct DarkTheme: Theme {
    let background = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    let surface = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    let primary = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    let secondary = Color(red: 0.64, green: 0.63, blue: 0.87) // #A29BDF
    let accent = Color(red: 1.0, green: 0.62, blue: 0.04) // #FF9F0A
    
    let textPrimary = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    let textSecondary = Color(red: 0.92, green: 0.92, blue: 0.96) // #EBEBF5
    let textTertiary = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    let textInverse = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    
    let borderPrimary = Color(red: 0.23, green: 0.23, blue: 0.26) // #3A3A3C
    let borderSecondary = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E
    let borderFocus = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    
    let success = Color(red: 0.19, green: 0.82, blue: 0.35) // #30D158
    let warning = Color(red: 1.0, green: 0.62, blue: 0.04) // #FF9F0A
    let error = Color(red: 1.0, green: 0.27, blue: 0.23) // #FF453A
    let info = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    
    let shadowColor = Color.black.opacity(0.3)
}

// MARK: - Theme Manager
enum AppearanceMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    @Published var appearanceMode: AppearanceMode = .system {
        didSet {
            updateTheme()
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "AppearanceMode")
        }
    }
    
    @Published var colorScheme: ColorScheme = .light
    
    init() {
        // Load saved preference
        if let savedMode = UserDefaults.standard.string(forKey: "AppearanceMode"),
           let mode = AppearanceMode(rawValue: savedMode) {
            self.appearanceMode = mode
        }
        
        // Set initial theme
        self.currentTheme = LightTheme()
        updateTheme()
    }
    
    private func updateTheme() {
        switch appearanceMode {
        case .light:
            currentTheme = LightTheme()
            colorScheme = .light
        case .dark:
            currentTheme = DarkTheme()
            colorScheme = .dark
        case .system:
            // This will be handled by the environment
            currentTheme = LightTheme() // Default, will be overridden by environment
        }
    }
    
    func setTheme(for colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            currentTheme = LightTheme()
        case .dark:
            currentTheme = DarkTheme()
        @unknown default:
            currentTheme = LightTheme()
        }
        self.colorScheme = colorScheme
    }
}

// MARK: - Theme Environment
struct ThemeEnvironment: ViewModifier {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) var systemColorScheme
    
    func body(content: Content) -> some View {
        content
            .environmentObject(themeManager)
            .onChange(of: systemColorScheme) { newColorScheme in
                if themeManager.appearanceMode == .system {
                    themeManager.setTheme(for: newColorScheme)
                }
            }
            .onAppear {
                if themeManager.appearanceMode == .system {
                    themeManager.setTheme(for: systemColorScheme)
                }
            }
            .preferredColorScheme(themeManager.appearanceMode == .system ? nil : themeManager.colorScheme)
    }
}

extension View {
    func withTheme() -> some View {
        modifier(ThemeEnvironment())
    }
}

// MARK: - Theme Switcher Component
struct ThemeSwitcher: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Picker("Appearance", selection: $themeManager.appearanceMode) {
            ForEach(AppearanceMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

