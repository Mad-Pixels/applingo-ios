import SwiftUI

struct LightTheme: AppTheme {
    // Main text colors
    let textPrimary = Color(hex: "1a1a1a")
    let textSecondary = Color(hex: "666666")
    let textContrast = Color(hex: "f5f7f4")
    
    // Main background colors
    let backgroundPrimary = Color.white
    let backgroundSecondary = Color(hex: "f4f4f4")
    let backgroundHover = Color(hex: "f0f0f0")
    let backgroundActive = Color(hex: "e8e8e8")
    let backgroundActiveHover = Color(hex: "e0e0e0")
    
    // Accent colors
    let accentPrimary = Color(hex: "2563eb")
    let accentLight = Color(hex: "3b82f6")
    let accentDark = Color(hex: "1d4ed8")
    let accentContrast = Color(hex: "2a2c29")
    
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
        
    // Patterns
    var mainPattern = DynamicPatternModel(colors: [
        Color(red: 0.12, green: 0.38, blue: 0.69),
        Color(red: 0.80, green: 0.50, blue: 0.83),
        Color(red: 0.47, green: 0.65, blue: 0.88),
        Color(red: 0.83, green: 0.10, blue: 0.53),
        Color(red: 0.09, green: 0.59, blue: 0.88),
        Color(red: 0.85, green: 0.85, blue: 0.86)
    ])
    
    // Quiz game
    var quizTheme: GameTheme {
        GameTheme(
            main: Color(hex: "E83371"),
            dark: Color(hex: "A22358"),
            light: Color(hex: "F280B3")
        )
    }
    
    // Match game
    var matchTheme: GameTheme {
        GameTheme(
            main: Color(hex: "4b5563"),
            dark: Color(hex: "f8a009"),
            light: Color(hex: "e38c10")
        )
    }
    
    // Sipe game
    var swipeTheme: GameTheme {
        GameTheme(
            main: Color(hex: "4b5563"),
            dark: Color(hex: "f8a009"),
            light: Color(hex: "e38c10")
        )
    }
}
