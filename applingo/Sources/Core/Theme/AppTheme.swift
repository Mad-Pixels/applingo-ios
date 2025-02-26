import SwiftUI

/// A protocol defining the theme of the application, including colors and styles for various UI elements.
protocol AppTheme {
    // MARK: - Text Colors
    /// Primary text color for main content.
    var textPrimary: Color { get }
    /// Secondary text color for less prominent content.
    var textSecondary: Color { get }
    /// Contrast text color for high-visibility areas.
    var textContrast: Color { get }
    
    // MARK: - Background Colors
    /// Primary background color.
    var backgroundPrimary: Color { get }
    /// Secondary background color.
    var backgroundSecondary: Color { get }
    /// Background color for hover states.
    var backgroundHover: Color { get }
    /// Background color for active states.
    var backgroundActive: Color { get }
    /// Background color for hover on active states.
    var backgroundActiveHover: Color { get }
    
    // MARK: - Accent Colors
    /// Primary accent color used for highlights.
    var accentPrimary: Color { get }
    /// Light variant of the primary accent color.
    var accentLight: Color { get }
    /// Dark variant of the primary accent color.
    var accentDark: Color { get }
    /// Contrast color used alongside accents.
    var accentContrast: Color { get }
    
    // MARK: - System Colors
    /// Color representing errors.
    var error: Color { get }
    /// Color representing success states.
    var success: Color { get }
    /// Color representing warnings.
    var warning: Color { get }
    /// Color representing informational messages.
    var info: Color { get }
    
    // MARK: - Card and Content
    /// Border color for cards.
    var cardBorder: Color { get }
    /// Background color for cards.
    var cardBackground: Color { get }
    /// Hover state background color for cards.
    var cardBackgroundHover: Color { get }
    
    // MARK: - Interactive States
    /// Color for hover states on interactive elements.
    var interactiveHover: Color { get }
    /// Color for disabled interactive elements.
    var interactiveDisabled: Color { get }
    /// Color for active interactive elements.
    var interactiveActive: Color { get }
    
    // MARK: - Error States
    /// Primary color for errors.
    var errorPrimaryColor: Color { get }
    /// Secondary color for errors.
    var errorSecondaryColor: Color { get }
    /// Background color for error states.
    var errorBackgroundColor: Color { get }
    
    // MARK: - Patterns
    /// Main dynamic pattern for the theme.
    var mainPattern: DynamicPatternModel { get }
    
    // MARK: - Game Themes
    /// Theme for quizzes.
    var quizTheme: GameTheme { get }
    /// Theme for matching games.
    var matchTheme: GameTheme { get }
    /// Theme for swipe-based games.
    var swipeTheme: GameTheme { get }
}
