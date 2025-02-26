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
    
    // MARK: - Pattern
    let pattern: DynamicPatternModel
    
    // MARK: - Layout Constants
    let widthRatio: CGFloat
    let heightRatio: CGFloat
    let maxHeight: CGFloat
    
    // MARK: - Pattern Animation Constants
    let patternOpacity: CGFloat
    let patternMinScale: CGFloat
    let patternAnimationDuration: Double
    
    // MARK: - Border Constants
    let borderWidth: CGFloat
    
    // MARK: - Shadow Constants
    let shadowOpacity: CGFloat
    let shadowOffset: CGPoint
    
    // MARK: - Text Constants
    let minScaleFactor: CGFloat
    let maxLines: Int
    let lineSpacing: CGFloat
    let textWidthRatio: CGFloat
    let textHeightRatio: CGFloat
    
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
        pattern: DynamicPatternModel,
        widthRatio: CGFloat = 0.9,
        heightRatio: CGFloat = 0.25,
        maxHeight: CGFloat = 250,
        patternOpacity: CGFloat = 0.2,
        patternMinScale: CGFloat = 0.95,
        patternAnimationDuration: Double = 4.0,
        borderWidth: CGFloat = 8,
        shadowOpacity: CGFloat = 0.15,
        shadowOffset: CGPoint = CGPoint(x: 0, y: 2),
        minScaleFactor: CGFloat = 0.5,
        maxLines: Int = 4,
        lineSpacing: CGFloat = 8,
        textWidthRatio: CGFloat = 0.9,
        textHeightRatio: CGFloat = 0.9
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
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.maxHeight = maxHeight
        self.patternOpacity = patternOpacity
        self.patternMinScale = patternMinScale
        self.patternAnimationDuration = patternAnimationDuration
        self.borderWidth = borderWidth
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.minScaleFactor = minScaleFactor
        self.maxLines = maxLines
        self.lineSpacing = lineSpacing
        self.textWidthRatio = textWidthRatio
        self.textHeightRatio = textHeightRatio
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
            questionFont: .title,
            optionFont: .body,
            cardCornerRadius: 32,
            optionCornerRadius: 10,
            cardPadding: 20,
            optionsPadding: 16,
            optionsSpacing: 12,
            cardShadowRadius: 5,
            optionShadowRadius: 2,
            pattern: theme.mainPattern,
            widthRatio: 0.9,
            heightRatio: 0.25,
            maxHeight: 250,
            patternOpacity: 0.2,
            patternMinScale: 0.95,
            patternAnimationDuration: 4.0,
            borderWidth: 8,
            shadowOpacity: 0.15,
            shadowOffset: CGPoint(x: 0, y: 2),
            minScaleFactor: 0.5,
            maxLines: 4,
            lineSpacing: 8,
            textWidthRatio: 0.9,
            textHeightRatio: 0.9
        )
    }
}
