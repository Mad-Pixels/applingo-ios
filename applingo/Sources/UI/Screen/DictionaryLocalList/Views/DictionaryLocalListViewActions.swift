import SwiftUI

/// A view that provides floating action buttons for import and download operations.
struct DictionaryLocalListViewActions: View {
    
    // MARK: - Properties
    
    let onImport: () -> Void
    let onDownload: () -> Void
    private let locale: DictionaryLocalListLocale
    
    // MARK: - Initializer
    
    /// Initializes the view with localized titles and action closures.
    /// - Parameters:
    ///   - locale: The localization object.
    ///   - onImport: Action closure for the import button.
    ///   - onDownload: Action closure for the download button.
    init(
        locale: DictionaryLocalListLocale,
        onImport: @escaping () -> Void,
        onDownload: @escaping () -> Void
    ) {
        self.locale = locale
        self.onImport = onImport
        self.onDownload = onDownload
    }
    
    // MARK: - Body
    
    var body: some View {
        ButtonFloatingMultiple(
            items: [
                ButtonFloatingModelIconAction(
                    icon: "tray.and.arrow.down",
                    action: onImport
                ),
                ButtonFloatingModelIconAction(
                    icon: "arrow.down.circle",
                    action: onDownload
                )
            ]
        )
    }
}
