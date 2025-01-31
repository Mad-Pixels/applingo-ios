import SwiftUI

/// A view that handles the import of dictionaries.
/// Provides UI for selecting a CSV file to import dictionary data.
struct DictionaryImport: View {
    
    // MARK: - Environment & State Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryImportStyle
    @StateObject private var locale = DictionaryImportLocale()
    
    /// Binding flag that controls the presentation of the file importer dialog.
    @Binding var isShowingFileImporter: Bool
    
    /// Flag to manage button press animation.
    @State private var isPressedTrailing = false
    
    // MARK: - Initializer
    
    /// Initializes the DictionaryImport view.
    /// - Parameters:
    ///   - isShowingFileImporter: Binding flag for showing the file importer.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(isShowingFileImporter: Binding<Bool>, style: DictionaryImportStyle? = nil) {
        self._isShowingFileImporter = isShowingFileImporter
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .DictionaryImport, title: locale.navigationTitle) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryImportViewTitle(locale: locale, style: style)
                    DictionaryImportViewTable(locale: locale, style: style)
                    DictionaryImportViewDescription(locale: locale, style: style)
                    DictionaryImportViewNote(locale: locale, style: style)
                }
                .padding(style.padding)
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .close(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isPressed: $isPressedTrailing
                    )
                }
            }
        }
        // Import CSV Button
        ButtonAction(
            title: locale.importCSVTitle,
            action: { isShowingFileImporter = true },
            style: .action(ThemeManager.shared.currentThemeStyle)
        )
        // File Importer Dialog
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [
                .plainText,
                .commaSeparatedText
                // For TSV support on iOS 15+, you can add .tabSeparatedText.
            ],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result: result)
        }
    }
    
    // MARK: - Private Methods
    
    /// Handles the result of the file importer dialog.
    /// - Parameter result: The result returned from the file importer.
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let fileURL = urls.first else {
                Logger.debug("[DictionaryImportView]: No file selected")
                return
            }
            // Call the parser to import the dictionary.
            let parser = DictionaryParser()
            parser.importDictionary(from: fileURL) { importResult in
                switch importResult {
                case .success:
                    Logger.debug("[DictionaryImportView]: Import successful")
                case .failure(let error):
                    Logger.debug("[DictionaryImportView]: Import failed", metadata: [
                        "error": "\(error)"
                    ])
                }
            }
        case .failure(let error):
            Logger.debug("[DictionaryImportView]: File picker error", metadata: [
                "error": "\(error)"
            ])
        }
    }
}
