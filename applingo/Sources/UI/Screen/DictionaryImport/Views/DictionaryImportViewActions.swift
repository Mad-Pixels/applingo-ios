import SwiftUI

/// A view that provides an action button for importing a dictionary CSV file.
///
/// This view displays a button to trigger the file importer for dictionary data.
struct DictionaryImportViewActions: View {
    
    // MARK: - Properties
    
    /// Closure to execute when the import button is pressed.
    let onImport: () -> Void
    
    /// The localization object providing the title for the import button.
    private let locale: DictionaryImportLocale
    
    // MARK: - Initialization
    
    /// Initializes the view with a localization object and an action handler.
    /// - Parameters:
    ///   - locale: The localization object providing button titles.
    ///   - onImport: A closure executed when the import button is tapped.
    init(locale: DictionaryImportLocale, onImport: @escaping () -> Void) {
        self.locale = locale
        self.onImport = onImport
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.importCSVTitle,
                action: onImport,
                style: .action(ThemeManager.shared.currentThemeStyle)
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
