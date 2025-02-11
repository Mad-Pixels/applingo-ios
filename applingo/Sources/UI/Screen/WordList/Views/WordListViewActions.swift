import SwiftUI

/// A view that provides a floating action button for adding a new word.
struct WordListViewActions: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle
    
    let onAdd: () -> Void
    
    // MARK: - Initializer
    /// Initializes the view with a localization object and add action.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    ///   - onAdd: Closure executed when the button is tapped.
    init(
        style: WordListStyle,
        locale: WordListLocale,
        onAdd: @escaping () -> Void
    ) {
        self.locale = locale
        self.style = style
        self.onAdd = onAdd
    }
    
    // MARK: - Body
    var body: some View {
        ButtonFloatingSingle(
            icon: "plus.circle",
            action: onAdd
        )
    }
}
