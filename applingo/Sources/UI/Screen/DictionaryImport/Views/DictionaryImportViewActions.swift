import SwiftUI

/// A view that provides an action button for importing a dictionary CSV file.
///
/// This view displays a button to trigger the file importer for dictionary data.
struct DictionaryImportViewActions: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle
    
    let onImport: () -> Void
    
    // MARK: - Initialization
    
    // MARK: - Initialization
    /// Initializes the view with localized titles and action handlers.
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
    
    // MARK: - Body
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.screenTitle.lowercased(),
                action: onImport,
                style: .action(ThemeManager.shared.currentThemeStyle)
            )
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
}
