# SwiftUI Design System

A comprehensive SwiftUI Design System providing consistent design tokens, components, and patterns for iOS applications. This system includes advanced features like dark/light theme support, typography system, elevation/shadows, border styles, layout system, and icon library.

## Features

- **🎨 Semantic Colors:** Comprehensive color palette with light/dark theme support
- **📏 Consistent Spacing:** 8-value spacing system based on 4pt base unit
- **🔤 Typography System:** 10 semantic text styles with proper hierarchy
- **🌟 Elevation System:** 6 shadow levels for depth and visual hierarchy
- **🔲 Border System:** Consistent border radius and styling options
- **📱 Layout System:** Responsive grid system with breakpoints for iOS devices
- **🎯 Icon System:** Comprehensive SF Symbols integration with semantic categorization
- **🌙 Theme Support:** Automatic light/dark mode with manual override options
- **🧩 Component Library:** Pre-built components following design system principles

## Installation

### Swift Package Manager

1. In Xcode, go to `File > Add Packages...`
2. Enter the repository URL: `https://github.com/your-username/SwiftUIDesignSystem.git`
3. Select `SwiftUIDesignSystem` and click `Add Package`

### Manual Installation

1. Download the source code
2. Drag the `SwiftUIDesignSystem` folder into your Xcode project
3. Ensure the files are added to your target

## Quick Start

### 1. Setup Theme Support

First, wrap your app with the theme environment:

```swift
import SwiftUI
import SwiftUIDesignSystem

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withTheme()
        }
    }
}
```

### 2. Using Colors

```swift
import SwiftUI
import SwiftUIDesignSystem

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Text("Hello, Design System!")
                .foregroundColor(themeManager.currentTheme.textPrimary)
                .padding()
                .background(themeManager.currentTheme.surface)
                .cornerRadius(BorderRadius.medium)
        }
        .background(themeManager.currentTheme.background)
    }
}
```

### 3. Using Typography

```swift
Text("Display Large")
    .font(.custom(.displayLarge))

Text("Body Text")
    .font(.custom(.body))

Text("Caption")
    .font(.custom(.caption1))
```

### 4. Using Spacing

```swift
VStack(spacing: Spacing.medium) {
    Text("Item 1")
    Text("Item 2")
    Text("Item 3")
}
.padding(Spacing.large)
```

### 5. Using Elevation

```swift
Rectangle()
    .fill(Color.white)
    .frame(width: 200, height: 100)
    .elevation(Elevation.level2)
```

### 6. Using Icons

```swift
// Basic icon
Icon(.heart, size: IconSize.medium, color: .red)

// Icon button
IconButton(.plus, size: IconSize.large) {
    print("Add button tapped")
}

// Convenience methods
Icon.large(.bookmark, color: .blue)
```

### 7. Using Layout System

```swift
Container(.fixed) {
    Grid {
        ForEach(items) { item in
            ItemView(item)
        }
    }
}
```

### 8. Using Button Component

```swift
VStack(spacing: Spacing.medium) {
    AppButton("Primary Action", style: .primary) {
        print("Primary tapped")
    }
    
    AppButton("Secondary", style: .secondary, size: .large) {
        print("Secondary tapped")
    }
    
    AppButton("Destructive", style: .destructive, isDisabled: false) {
        print("Destructive tapped")
    }
}
```

## Design Tokens

### Colors

The design system includes semantic color names that automatically adapt to light/dark themes:

- **Brand Colors:** `brandPrimary`, `brandSecondary`
- **Neutral Colors:** `neutral0` through `neutral400`
- **Semantic Colors:** `textPrimary`, `textSecondary`, `backgroundPrimary`, `accentColor`
- **Status Colors:** `successColor`, `warningColor`, `errorColor`

### Spacing

Based on a 4pt base unit:

- `Spacing.xxSmall` (2pt)
- `Spacing.xSmall` (4pt)
- `Spacing.small` (8pt)
- `Spacing.medium` (16pt)
- `Spacing.large` (24pt)
- `Spacing.xLarge` (32pt)
- `Spacing.xxLarge` (48pt)
- `Spacing.xxxLarge` (64pt)

### Typography

10 semantic text styles:

- `displayLarge` (48pt, Bold)
- `displayMedium` (36pt, Bold)
- `headline` (24pt, Semibold)
- `title1` (20pt, Semibold)
- `title2` (18pt, Medium)
- `body` (17pt, Regular)
- `callout` (16pt, Regular)
- `subhead` (15pt, Regular)
- `footnote` (13pt, Regular)
- `caption1` (12pt, Regular)

### Elevation

6 shadow levels for depth:

- `Elevation.none` - No shadow
- `Elevation.level1` - Subtle elevation
- `Elevation.level2` - Low elevation
- `Elevation.level3` - Medium elevation
- `Elevation.level4` - High elevation
- `Elevation.level5` - Maximum elevation

### Border Radius

Consistent rounding values:

- `BorderRadius.none` (0pt)
- `BorderRadius.small` (4pt)
- `BorderRadius.medium` (8pt)
- `BorderRadius.large` (12pt)
- `BorderRadius.extraLarge` (16pt)
- `BorderRadius.round` (50%)

### Icons

Comprehensive SF Symbols integration organized by category:

- **Navigation:** chevrons, house, menu
- **Actions:** plus, minus, edit, delete, share
- **Status:** checkmarks, errors, warnings, info
- **Content:** documents, photos, videos, music
- **Communication:** messages, phone, email
- **Interface:** search, settings, help

## Components

### AppButton

A flexible button component with multiple styles and sizes:

```swift
AppButton("Button Text", style: .primary, size: .medium) {
    // Action
}
```

**Styles:** `.primary`, `.secondary`, `.outline`, `.ghost`, `.destructive`
**Sizes:** `.small`, `.medium`, `.large`

### Icon & IconButton

Consistent icon usage with SF Symbols:

```swift
Icon(.heart, size: IconSize.large, color: .red)
IconButton(.plus) { /* action */ }
```

### Container & Grid

Responsive layout components:

```swift
Container(.fixed) {
    Grid {
        // Grid items
    }
}
```

**Container Types:** `.fluid`, `.fixed`, `.compact`

## Theme System

### Automatic Theme Detection

The system automatically detects and responds to system-wide appearance changes.

### Manual Theme Control

```swift
struct ThemeControlView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            ThemeSwitcher()
            
            // Manual theme setting
            Button("Light Theme") {
                themeManager.appearanceMode = .light
            }
            
            Button("Dark Theme") {
                themeManager.appearanceMode = .dark
            }
            
            Button("System Theme") {
                themeManager.appearanceMode = .system
            }
        }
    }
}
```

## Responsive Design

The layout system includes breakpoints for different iOS devices:

- **Compact:** < 428pt (iPhone SE, iPhone mini)
- **Regular:** 428pt - 768pt (Standard iPhones)
- **Large:** 768pt - 1024pt (iPad portrait)
- **Extra Large:** > 1024pt (iPad landscape)

## Best Practices

### 1. Use Semantic Names

Always use semantic color and spacing names rather than specific values:

```swift
// ✅ Good
.foregroundColor(themeManager.currentTheme.textPrimary)
.padding(Spacing.medium)

// ❌ Avoid
.foregroundColor(.black)
.padding(16)
```

### 2. Leverage Theme Support

Design components to work in both light and dark themes:

```swift
struct MyCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            // Content
        }
        .background(themeManager.currentTheme.surface)
        .foregroundColor(themeManager.currentTheme.textPrimary)
    }
}
```

### 3. Use Consistent Spacing

Apply spacing consistently using the defined scale:

```swift
VStack(spacing: Spacing.medium) {
    // Items
}
.padding(.horizontal, Spacing.large)
.padding(.vertical, Spacing.medium)
```

### 4. Follow Typography Hierarchy

Use appropriate text styles for content hierarchy:

```swift
VStack(alignment: .leading, spacing: Spacing.small) {
    Text("Main Title")
        .font(.custom(.headline))
    
    Text("Subtitle")
        .font(.custom(.title2))
    
    Text("Body content goes here...")
        .font(.custom(.body))
    
    Text("Additional info")
        .font(.custom(.footnote))
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions, issues, or feature requests, please open an issue on GitHub or contact the development team.

---

**Website:** [Design System Documentation](https://znqzqxgl.manus.space)

