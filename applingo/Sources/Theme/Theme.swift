import SwiftUI

protocol ThemeStyle {
    // Main text colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    
    // Main background colors
    var backgroundPrimary: Color { get }
    var backgroundSecondary: Color { get }
    var backgroundHover: Color { get }
    var backgroundActive: Color { get }
    var backgroundActiveHover: Color { get }
    
    // Accent colors
    var accentPrimary: Color { get }
    var accentLight: Color { get }
    var accentDark: Color { get }
    var accentContrast: Color { get }
    
    // System colors
    var error: Color { get }
    var success: Color { get }
    var warning: Color { get }
    var info: Color { get }
    
    // Card and content
    var cardBorder: Color { get }
    var cardBackground: Color { get }
    var cardBackgroundHover: Color { get }
    
    // Interactive states
    var interactiveHover: Color { get }
    var interactiveDisabled: Color { get }
    var interactiveActive: Color { get }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
