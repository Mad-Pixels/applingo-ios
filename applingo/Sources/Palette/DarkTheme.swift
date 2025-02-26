import SwiftUI

struct DarkTheme: AppTheme {
    // Main text colors
    let textPrimary = Color(hex: "f5f7f4")
    let textSecondary = Color(hex: "9ca3af")
    let textContrast = Color(hex: "1a1a1a")
    
    // Main background colors
    let backgroundPrimary = Color(hex: "131512")
    let backgroundSecondary = Color(hex: "2a2c29")
    let backgroundHover = Color(hex: "333333")
    let backgroundActive = Color(hex: "404040")
    let backgroundActiveHover = Color(hex: "4a4a4a")
    
    // Accent colors
    let accentPrimary = Color(hex: "aae282")
    let accentLight = Color(hex: "e38c10")
    let accentDark = Color(hex: "80ac60")
    let accentContrast = Color.white
    
    // System colors
    let success = Color(hex: "22c55e")
    let warning = Color(hex: "eab308")
    let error = Color(hex: "ef4444")
    let info = Color(hex: "06b6d4")
    
    // Card and content
    let cardBorder = Color(hex: "333333")
    let cardBackground = Color(hex: "262626")
    let cardBackgroundHover = Color(hex: "333333")
    
    // Interactive states
    let interactiveDisabled = Color(hex: "4b5563")
    let interactiveActive = Color(hex: "f8a009")
    let interactiveHover = Color(hex: "e38c10")
    
    // Error colors
    var errorPrimaryColor: Color { Color(hex: "ef4444") }
    var errorSecondaryColor: Color { Color(hex: "f87171") }
    var errorBackgroundColor: Color { Color(hex: "7f1d1d") }
    
    // Patterns
    var mainPattern = DynamicPatternModel(colors: [
        Color(hex: "90A4AE"),
        Color(hex: "B0BEC5"),
        Color(hex: "CFD8DC"),
        Color(hex: "78909C"),
        Color(hex: "546E7A"),
    ])
    
    // Quiz game
    var quizTheme: GameTheme {
        GameTheme(
            main: Color(hex: "f8a009"),
            secondary: Color(hex: "748aa8"),
            accent: Color(hex: "84bf4d")
        )
    }
        
    // Match game
    var matchTheme: GameTheme {
        GameTheme(
            main: Color(hex: "4b5563"),
            secondary: Color(hex: "f8a009"),
            accent: Color(hex: "e38c10")
        )
    }
    
    // Swipe game
    var swipeTheme: GameTheme {
        GameTheme(
            main: Color(hex: "4b5563"),
            secondary: Color(hex: "f8a009"),
            accent: Color(hex: "e38c10")
        )
    }
}
