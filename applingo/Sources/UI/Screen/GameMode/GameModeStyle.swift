import SwiftUI

final class GameModeStyle: ObservableObject {
    let pattern: DynamicPatternModel
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let cardSpacing: CGFloat
    let titleStyle: TextStyle
    
    struct TextStyle {
        let font: Font
        let color: Color
    }
    
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        cardSpacing: CGFloat,
        titleStyle: TextStyle,
        pattern: DynamicPatternModel
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
        self.cardSpacing = cardSpacing
        self.titleStyle = titleStyle
        self.pattern = pattern
    }
}

extension GameModeStyle {
    static func themed(_ theme: AppTheme, gameTheme: GameTheme) -> GameModeStyle {
        GameModeStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            cardSpacing: 16,
            titleStyle: TextStyle(
                font: .system(.title, design: .rounded).weight(.bold),
                color: gameTheme.dark
            ),
            pattern: gameTheme.pattern
        )
    }
}
