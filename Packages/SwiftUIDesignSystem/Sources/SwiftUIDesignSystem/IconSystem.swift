import SwiftUI

// MARK: - Icon Sizes
struct IconSize {
    static let extraSmall: CGFloat = 12
    static let small: CGFloat = 16
    static let medium: CGFloat = 20
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
    static let huge: CGFloat = 48
}

// MARK: - Icon Categories and Names
enum AppIcon: String, CaseIterable {
    // Navigation
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case house = "house"
    case house_fill = "house.fill"
    case line_horizontal_3 = "line.horizontal.3"
    
    // Actions
    case plus = "plus"
    case plus_circle = "plus.circle"
    case minus = "minus"
    case minus_circle = "minus.circle"
    case pencil = "pencil"
    case trash = "trash"
    case square_and_arrow_up = "square.and.arrow.up"
    case heart = "heart"
    case heart_fill = "heart.fill"
    case bookmark = "bookmark"
    case bookmark_fill = "bookmark.fill"
    
    // Status
    case checkmark_circle = "checkmark.circle"
    case checkmark_circle_fill = "checkmark.circle.fill"
    case xmark_circle = "xmark.circle"
    case xmark_circle_fill = "xmark.circle.fill"
    case exclamationmark_triangle = "exclamationmark.triangle"
    case exclamationmark_triangle_fill = "exclamationmark.triangle.fill"
    case info_circle = "info.circle"
    case info_circle_fill = "info.circle.fill"
    
    // Content
    case doc = "doc"
    case doc_fill = "doc.fill"
    case photo = "photo"
    case photo_fill = "photo.fill"
    case video = "video"
    case video_fill = "video.fill"
    case music_note = "music.note"
    
    // Communication
    case message = "message"
    case message_fill = "message.fill"
    case phone = "phone"
    case phone_fill = "phone.fill"
    case envelope = "envelope"
    case envelope_fill = "envelope.fill"
    
    // Interface
    case magnifyingglass = "magnifyingglass"
    case line_horizontal_3_decrease = "line.horizontal.3.decrease"
    case gearshape = "gearshape"
    case gearshape_fill = "gearshape.fill"
    case questionmark_circle = "questionmark.circle"
    case questionmark_circle_fill = "questionmark.circle.fill"
    
    var category: IconCategory {
        switch self {
        case .chevronLeft, .chevronRight, .chevronUp, .chevronDown, .house, .house_fill, .line_horizontal_3:
            return .navigation
        case .plus, .plus_circle, .minus, .minus_circle, .pencil, .trash, .square_and_arrow_up, .heart, .heart_fill, .bookmark, .bookmark_fill:
            return .actions
        case .checkmark_circle, .checkmark_circle_fill, .xmark_circle, .xmark_circle_fill, .exclamationmark_triangle, .exclamationmark_triangle_fill, .info_circle, .info_circle_fill:
            return .status
        case .doc, .doc_fill, .photo, .photo_fill, .video, .video_fill, .music_note:
            return .content
        case .message, .message_fill, .phone, .phone_fill, .envelope, .envelope_fill:
            return .communication
        case .magnifyingglass, .line_horizontal_3_decrease, .gearshape, .gearshape_fill, .questionmark_circle, .questionmark_circle_fill:
            return .interface
        }
    }
}

enum IconCategory: String, CaseIterable {
    case navigation = "Navigation"
    case actions = "Actions"
    case status = "Status"
    case content = "Content"
    case communication = "Communication"
    case interface = "Interface"
}

// MARK: - Icon Component
struct Icon: View {
    let name: AppIcon
    let size: CGFloat
    let weight: Font.Weight
    let color: Color?
    
    init(
        _ name: AppIcon,
        size: CGFloat = IconSize.medium,
        weight: Font.Weight = .regular,
        color: Color? = nil
    ) {
        self.name = name
        self.size = size
        self.weight = weight
        self.color = color
    }
    
    var body: some View {
        Image(systemName: name.rawValue)
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

// MARK: - Convenience Extensions
extension Icon {
    // Size variants
    static func extraSmall(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.extraSmall, weight: weight, color: color)
    }
    
    static func small(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.small, weight: weight, color: color)
    }
    
    static func medium(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.medium, weight: weight, color: color)
    }
    
    static func large(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.large, weight: weight, color: color)
    }
    
    static func extraLarge(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.extraLarge, weight: weight, color: color)
    }
    
    static func huge(_ name: AppIcon, weight: Font.Weight = .regular, color: Color? = nil) -> Icon {
        Icon(name, size: IconSize.huge, weight: weight, color: color)
    }
}

// MARK: - Icon Button Component
struct IconButton: View {
    let icon: AppIcon
    let action: () -> Void
    let size: CGFloat
    let weight: Font.Weight
    let color: Color?
    
    init(
        _ icon: AppIcon,
        size: CGFloat = IconSize.medium,
        weight: Font.Weight = .regular,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.weight = weight
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Icon(icon, size: size, weight: weight, color: color)
        }
    }
}

