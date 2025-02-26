import SwiftUI

/// A view that provides a floating action button for filtering remote dictionaries.
struct DictionaryRemoteListViewActions: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle
    
    let onFilter: () -> Void
    
    // MARK: - Initializer
    /// Initializes the view with a localization object and add action.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    ///   - onFilter: Action closure to open the filter view.
    init(
        style: DictionaryRemoteListStyle,
        locale: DictionaryRemoteListLocale,
        onFilter: @escaping () -> Void
    ) {
        self.locale = locale
        self.style = style
        self.onFilter = onFilter
    }
    
    // MARK: - Body
    var body: some View {
        ButtonFloatingSingle(
            icon: "line.horizontal.3.decrease.circle",
            action: onFilter
        )
    }
}
