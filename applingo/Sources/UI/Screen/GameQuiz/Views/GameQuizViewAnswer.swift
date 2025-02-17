import SwiftUI

/// A view that displays a single quiz answer option as a button.
///
/// This view renders an answer option using the provided visual style and localization.
/// When tapped, it triggers the supplied action closure to handle the answer selection.
/// The button’s appearance—including its font, text color, padding, background, corner radius,
/// and shadow—is defined by the provided `GameQuizStyle`. Additionally, a custom button style
/// is applied to handle the pressed state.
///
/// - Environment:
///   - `themeManager`: Provides the current theme settings.
/// - Properties:
///   - `locale`: A `GameQuizLocale` object supplying localized strings for the quiz view.
///   - `style`: A `GameQuizStyle` object defining the visual appearance for the answer option.
///   - `option`: The answer option text to display.
///   - `onSelect`: An action closure executed when the answer option is tapped.
struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let option: String
    private let onSelect: () -> Void
    
    /// Initializes a new instance of `GameQuizViewAnswer`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object defining the appearance for the answer option.
    ///   - option: The answer option text to display.
    ///   - onSelect: The action to execute when the answer option is selected.
    init(locale: GameQuizLocale, style: GameQuizStyle, option: String, onSelect: @escaping () -> Void) {
        self.locale = locale
        self.style = style
        self.option = option
        self.onSelect = onSelect
    }
    
    var body: some View {
        ButtonAction(
            title: option,
            action: onSelect,
            style: .gameAnswer(themeManager.currentThemeStyle)
        )
    }
}
