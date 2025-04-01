import SwiftUI

final class GameQuizStyle: ObservableObject {
    // Colors
    let backgroundColor: Color
    let cardBackground: Color

    // Layout & Sizing
    let cardCornerRadius: CGFloat
    let cardPadding: CGFloat
    let optionsPadding: CGFloat
    let optionsSpacing: CGFloat
    let widthRatio: CGFloat
    let heightRatio: CGFloat
    let maxHeight: CGFloat

    // Shadows
    let cardShadowRadius: CGFloat
    let shadowOffset: CGPoint

    // Pattern & Animation
    let pattern: DynamicPatternModel
    let patternOpacity: CGFloat
    let patternMinScale: CGFloat
    let patternAnimationDuration: Double

    // Border
    let borderWidth: CGFloat

    // Text Layout
    let textWidthRatio: CGFloat
    let textHeightRatio: CGFloat

    init(
        backgroundColor: Color,
        cardBackground: Color,
        cardCornerRadius: CGFloat = 32,
        cardPadding: CGFloat = 20,
        optionsPadding: CGFloat = 16,
        optionsSpacing: CGFloat = 12,
        widthRatio: CGFloat = 0.9,
        heightRatio: CGFloat = 0.25,
        maxHeight: CGFloat = 250,
        cardShadowRadius: CGFloat = 5,
        shadowOffset: CGPoint = CGPoint(x: 0, y: 2),
        pattern: DynamicPatternModel,
        patternOpacity: CGFloat = 0.2,
        patternMinScale: CGFloat = 0.95,
        patternAnimationDuration: Double = 4.0,
        borderWidth: CGFloat = 8,
        textWidthRatio: CGFloat = 0.9,
        textHeightRatio: CGFloat = 0.9
    ) {
        self.backgroundColor = backgroundColor
        self.cardBackground = cardBackground
        self.cardCornerRadius = cardCornerRadius
        self.cardPadding = cardPadding
        self.optionsPadding = optionsPadding
        self.optionsSpacing = optionsSpacing
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.maxHeight = maxHeight
        self.cardShadowRadius = cardShadowRadius
        self.shadowOffset = shadowOffset
        self.pattern = pattern
        self.patternOpacity = patternOpacity
        self.patternMinScale = patternMinScale
        self.patternAnimationDuration = patternAnimationDuration
        self.borderWidth = borderWidth
        self.textWidthRatio = textWidthRatio
        self.textHeightRatio = textHeightRatio
    }
}

extension GameQuizStyle {
    static func themed(_ theme: AppTheme) -> GameQuizStyle {
        GameQuizStyle(
            backgroundColor: theme.backgroundPrimary,
            cardBackground: theme.cardBackground,
            cardCornerRadius: 32,
            cardPadding: 20,
            optionsPadding: 16,
            optionsSpacing: 12,
            widthRatio: 0.9,
            heightRatio: 0.25,
            maxHeight: 250,
            cardShadowRadius: 5,
            shadowOffset: CGPoint(x: 0, y: 2),
            pattern: theme.mainPattern,
            patternOpacity: 0.2,
            patternMinScale: 0.95,
            patternAnimationDuration: 4.0,
            borderWidth: 8,
            textWidthRatio: 0.9,
            textHeightRatio: 0.9
        )
    }
}
