import SwiftUI

/// A view that provides a floating action button for adding a new word.
struct WordListViewActions: View {
    
    // MARK: - Properties
    
    /// Action executed when the add button is tapped.
    let onAdd: () -> Void
    private let locale: WordListLocale
    
    // MARK: - Initializer
    
    /// Initializes the view with a localization object and add action.
    /// - Parameters:
    ///   - locale: Localization object.
    ///   - onAdd: Closure executed when the button is tapped.
    init(
        locale: WordListLocale,
        onAdd: @escaping () -> Void
    ) {
        self.locale = locale
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
