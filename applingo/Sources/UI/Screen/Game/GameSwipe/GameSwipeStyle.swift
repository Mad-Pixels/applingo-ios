import SwiftUI

final class GameSwipeStyle: ObservableObject {
    // Layouts
    let floatingButtonPadding: CGFloat
    let cardTextPadding: CGFloat
    let cornerRadius: CGFloat
    
    // Colors
    let backgroundColor: Color
    let textSecondaryColor: Color
    
    init(
        floatingButtonPadding: CGFloat,
        cardTextPadding: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: Color,
        textSecondaryColor: Color
        
    ) {
        self.floatingButtonPadding = floatingButtonPadding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.cardTextPadding = cardTextPadding
        self.textSecondaryColor = textSecondaryColor
    }
}

extension GameSwipeStyle {
    static func themed(_ theme: AppTheme) -> GameSwipeStyle {
        GameSwipeStyle(
            floatingButtonPadding: 32,
            cardTextPadding: 24,
            cornerRadius: 20,
            backgroundColor: theme.backgroundPrimary,
            textSecondaryColor: theme.textSecondary
        )
    }
}
