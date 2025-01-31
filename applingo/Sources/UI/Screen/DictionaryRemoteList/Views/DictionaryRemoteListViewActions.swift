import SwiftUI

/// A view that provides a floating action button for filtering remote dictionaries.
struct DictionaryRemoteListViewActions: View {
    
    // MARK: - Properties
    
    let onFilter: () -> Void
    private let locale: DictionaryRemoteListLocale
    
    // MARK: - Initializer
    
    /// Initializes the view with the localization object and a filter action.
    /// - Parameters:
    ///   - locale: The localization object.
    ///   - onFilter: Action closure to open the filter view.
    init(
        locale: DictionaryRemoteListLocale,
        onFilter: @escaping () -> Void
    ) {
        self.locale = locale
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
