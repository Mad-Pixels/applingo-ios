import SwiftUI

final class GameQuizStyle: ObservableObject {
    // MARK: - Colors
    let backgroundColor: Color
    let cardBackground: Color
    let cardBorder: Color
    let questionTextColor: Color
    let optionBackground: Color
    let optionBackgroundPressed: Color
    let optionTextColor: Color
    
    // MARK: - Fonts & Sizes
    let questionFont: Font
    let optionFont: Font
    let cardCornerRadius: CGFloat
    let optionCornerRadius: CGFloat
    let cardPadding: CGFloat
    let optionsPadding: CGFloat
    let optionsSpacing: CGFloat
    
    // MARK: - Shadows
    let cardShadowRadius: CGFloat
    let optionShadowRadius: CGFloat

    // MARK: - New Pattern Property
    let pattern: DynamicPatternModel
    
    init(
        backgroundColor: Color,
        cardBackground: Color,
        cardBorder: Color,
        questionTextColor: Color,
        optionBackground: Color,
        optionBackgroundPressed: Color,
        optionTextColor: Color,
        questionFont: Font = .title,
        optionFont: Font = .body,
        cardCornerRadius: CGFloat = 20,
        optionCornerRadius: CGFloat = 10,
        cardPadding: CGFloat = 20,
        optionsPadding: CGFloat = 16,
        optionsSpacing: CGFloat = 12,
        cardShadowRadius: CGFloat = 5,
        optionShadowRadius: CGFloat = 2,
        pattern: DynamicPatternModel
    ) {
        self.backgroundColor = backgroundColor
        self.cardBackground = cardBackground
        self.cardBorder = cardBorder
        self.questionTextColor = questionTextColor
        self.optionBackground = optionBackground
        self.optionBackgroundPressed = optionBackgroundPressed
        self.optionTextColor = optionTextColor
        self.questionFont = questionFont
        self.optionFont = optionFont
        self.cardCornerRadius = cardCornerRadius
        self.optionCornerRadius = optionCornerRadius
        self.cardPadding = cardPadding
        self.optionsPadding = optionsPadding
        self.optionsSpacing = optionsSpacing
        self.cardShadowRadius = cardShadowRadius
        self.optionShadowRadius = optionShadowRadius
        self.pattern = pattern
    }
}

// MARK: - Themed Style Extension
extension GameQuizStyle {
    static func themed(_ theme: AppTheme) -> GameQuizStyle {
        GameQuizStyle(
            backgroundColor: theme.backgroundPrimary,
            cardBackground: theme.cardBackground,
            cardBorder: theme.cardBorder,
            questionTextColor: theme.textPrimary,
            optionBackground: theme.backgroundSecondary,
            optionBackgroundPressed: theme.backgroundActive,
            optionTextColor: theme.textPrimary,
            // Use default fonts and sizes or customize as needed:
            questionFont: .title,
            optionFont: .body,
            cardCornerRadius: 32,
            optionCornerRadius: 10,
            cardPadding: 20,
            optionsPadding: 16,
            optionsSpacing: 12,
            cardShadowRadius: 5,
            optionShadowRadius: 2,
            // Provide the theme's main pattern as the dynamic pattern
            pattern: theme.mainPattern
        )
    }
}
