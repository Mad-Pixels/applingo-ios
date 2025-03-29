import SwiftUI

internal struct DictionaryImportViewActions: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle
    
    internal let onImport: () -> Void
    
    /// Initializes the DictionaryImportViewActions.
    /// - Parameters:
    ///   - style: `DictionaryImportStyle` style configuration.
    ///   - locale: `DictionaryImportLocale` localization object.
    ///   - onImport: A closure executed when the import button is tapped.
    init(
        style: DictionaryImportStyle,
        locale: DictionaryImportLocale,
        onImport: @escaping () -> Void
    ) {
        self.locale = locale
        self.style = style
        self.onImport = onImport
    }
    
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.screenTitle.lowercased(),
                action: onImport,
                style: .action(themeManager.currentThemeStyle)
            )
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
}
