import SwiftUI

protocol AppTheme {
    // Main text colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textContrast: Color { get }
    
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
    
    // Errors
    var errorPrimaryColor: Color { get }
    var errorSecondaryColor: Color { get }
    var errorBackgroundColor: Color { get }
    
    // Patterns
    var mainPattern: DynamicPatternModel { get }
    
    // Game themes
    var quizTheme: GameTheme { get }
    var matchTheme: GameTheme { get }
    var swipeTheme: GameTheme { get }
}
