import SwiftUI

/// A view that provides floating action buttons for import and download operations.
struct DictionaryLocalListViewActions: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryLocalListLocale
    private let style: DictionaryLocalListStyle
    
    let onImport: () -> Void
    let onDownload: () -> Void
    
    // MARK: - Initializer
    /// Initializes the view with localized titles and action closures.
    /// - Parameters:
    ///   - style: `DictionaryLocalListStyle` object that defines the visual style.
    ///   - locale: `DictionaryLocalListLocale` object that provides localized strings.
    ///   - onImport: Action closure for the import button.
    ///   - onDownload: Action closure for the download button.
    init(
        style: DictionaryLocalListStyle,
        locale: DictionaryLocalListLocale,
        onImport: @escaping () -> Void,
        onDownload: @escaping () -> Void
    ) {
        self.onDownload = onDownload
        self.onImport = onImport
        self.locale = locale
        self.style = style
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
