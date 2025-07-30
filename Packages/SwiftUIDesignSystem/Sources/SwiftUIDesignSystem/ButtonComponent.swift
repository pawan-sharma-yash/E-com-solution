import SwiftUI

enum ButtonStyleType {
    case primary
    case secondary
    case outline
    case ghost
    case destructive
}

enum ButtonSizeType {
    case small
    case medium
    case large
}

struct AppButton: View {
    let title: String
    let style: ButtonStyleType
    let size: ButtonSizeType
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
        _ title: String,
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                }
                Text(title)
            }
            .font(.custom(.callout))
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(height: buttonHeight)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(BorderRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.medium)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled || isLoading)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return themeManager.currentTheme.primary
        case .secondary: return themeManager.currentTheme.secondary
        case .outline, .ghost: return .clear
        case .destructive: return themeManager.currentTheme.error
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .destructive: return themeManager.currentTheme.textInverse
        case .secondary: return themeManager.currentTheme.textPrimary
        case .outline: return themeManager.currentTheme.primary
        case .ghost: return themeManager.currentTheme.textPrimary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline: return themeManager.currentTheme.primary
        default: return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline: return BorderWidth.thin
        default: return BorderWidth.none
        }
    }
    
    private var buttonHeight: CGFloat {
        switch size {
        case .small: return 32
        case .medium: return 44
        case .large: return 56
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return Spacing.small
        case .medium: return Spacing.medium
        case .large: return Spacing.large
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: return Spacing.xSmall
        case .medium: return Spacing.small
        case .large: return Spacing.medium
        }
    }
}

