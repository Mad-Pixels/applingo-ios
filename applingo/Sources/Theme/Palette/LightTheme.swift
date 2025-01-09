import SwiftUI

struct LightTheme: AppTheme {
    // Main text colors
    let textPrimary = Color(hex: "1a1a1a")
    let textSecondary = Color(hex: "666666")
    
    // Main background colors
    let backgroundPrimary = Color.white
    let backgroundSecondary = Color(hex: "f8f8f8")
    let backgroundHover = Color(hex: "f0f0f0")
    let backgroundActive = Color(hex: "e8e8e8")
    let backgroundActiveHover = Color(hex: "e0e0e0")
    
    // Accent colors
    let accentPrimary = Color(hex: "2563eb")
    let accentLight = Color(hex: "3b82f6")
    let accentDark = Color(hex: "1d4ed8")
    let accentContrast = Color.white
    
    // System colors
    let success = Color(hex: "16a34a")
    let warning = Color(hex: "ca8a04")
    let error = Color(hex: "dc2626")
    let info = Color(hex: "0891b2")
    
    // Card and content
    let cardBackground = Color.white
    let cardBorder = Color(hex: "e5e7eb")
    let cardBackgroundHover = Color(hex: "f8f8f8")
    
    // Interactive states
    let interactiveDisabled = Color(hex: "d1d5db")
    let interactiveActive = Color(hex: "2563eb")
    let interactiveHover = Color(hex: "1d4ed8")
    
    // Error colors
    var errorPrimaryColor: Color { Color(hex: "dc2626") }
    var errorSecondaryColor: Color { Color(hex: "ef4444") }
    var errorBackgroundColor: Color { Color(hex: "fee2e2") }
}
