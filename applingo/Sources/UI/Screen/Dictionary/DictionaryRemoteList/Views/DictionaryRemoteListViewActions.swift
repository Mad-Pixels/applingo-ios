import SwiftUI

internal struct DictionaryRemoteListViewActions: View {
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle
    
    internal let onFilter: () -> Void
    
    /// Initializes the DictionaryRemoteListViewActions.
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
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "line.horizontal.3.decrease.circle",
            action: onFilter
        )
    }
}
