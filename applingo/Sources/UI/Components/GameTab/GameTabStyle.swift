import SwiftUI

final class GameTabStyle: ObservableObject {
    // Colors
    let textPrimaryColor: Color
    let textSecondaryColor: Color
    let accentColor: Color
    let dividerColor: Color
    let heartColor: Color
    
    // Typography
    let titleFont: Font
    let valueFont: Font
    let timerFont: Font
    
    // Layout
    let spacing: CGFloat
    let padding: CGFloat
    let dividerHeight: CGFloat
    let iconSize: CGFloat
    let modeSectionSize: CGFloat
    let tabWidth: CGFloat
    
    /// Initializes the GameTabStyle.
    /// - Parameters:
    ///   - textPrimaryColor: The primary text color.
    ///   - textSecondaryColor: The secondary text color.
    ///   - accentColor: The accent color.
    ///   - dividerColor: The divider color.
    ///   - titleFont: The font for titles.
    ///   - valueFont: The font for values.
    ///   - timerFont: The font for the timer.
    ///   - spacing: The spacing between elements.
    ///   - padding: The overall padding.
    ///   - dividerHeight: The height of the divider.
    ///   - iconSize: The size of icons.
    ///   - modeSectionSize: The size of the additional section for specific modes.
    ///   - tabWidth: The width of the Game Tab.
    ///   - heartColor: The color used for the heart indicator.
    init(
        textPrimaryColor: Color,
        textSecondaryColor: Color,
        accentColor: Color,
        dividerColor: Color,
        titleFont: Font,
        valueFont: Font,
        timerFont: Font,
        spacing: CGFloat,
        padding: CGFloat,
        dividerHeight: CGFloat,
        iconSize: CGFloat,
        modeSectionSize: CGFloat,
        tabWidth: CGFloat,
        heartColor: Color
    ) {
        self.textPrimaryColor = textPrimaryColor
        self.textSecondaryColor = textSecondaryColor
        self.accentColor = accentColor
        self.dividerColor = dividerColor
        self.titleFont = titleFont
        self.valueFont = valueFont
        self.timerFont = timerFont
        self.spacing = spacing
        self.padding = padding
        self.dividerHeight = dividerHeight
        self.iconSize = iconSize
        self.modeSectionSize = modeSectionSize
        self.tabWidth = tabWidth
        self.heartColor = heartColor
    }
}

extension GameTabStyle {
    static func themed(_ theme: AppTheme) -> GameTabStyle {
        GameTabStyle(
            textPrimaryColor: theme.textPrimary,
            textSecondaryColor: theme.textSecondary,
            accentColor: theme.accentPrimary,
            dividerColor: theme.textSecondary.opacity(0.2),
            titleFont: .system(size: 12, weight: .medium),
            valueFont: .system(size: 16, weight: .bold),
            timerFont: .system(size: 18, weight: .heavy),
            spacing: 16,
            padding: 16,
            dividerHeight: 24,
            iconSize: 16,
            modeSectionSize: 60,
            tabWidth: 0.9,
            heartColor: theme.errorPrimaryColor
        )
    }
}
