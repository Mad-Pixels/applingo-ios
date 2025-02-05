import SwiftUI

/// A view that handles the import of dictionaries.
/// Provides UI for selecting a CSV file to import dictionary data.
struct DictionaryImport: View {
    
    // MARK: - Environment & State Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryImportStyle
    @StateObject private var locale = DictionaryImportLocale()
    
    @State private var isShowingFileImporter = false
    @State private var isPressedTrailing = false
    
    // MARK: - Initializer
    
    /// Initializes the DictionaryImport view.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(style: DictionaryImportStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
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
                            onTap: { presentationMode.wrappedValue.dismiss() },
                            isPressed: $isPressedTrailing
                        )
                    }
                }
            }
            
            DictionaryImportViewActions(locale: locale, onImport: {
                isShowingFileImporter = true
            })
        }
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
            guard let fileURL = urls.first else { return }
            let parser = DictionaryParser()
            parser.importDictionary(from: fileURL) { importResult in
                // Handle the import result if needed.
            }
        case .failure(let error):
            Logger.debug("[Import]: File picker error", metadata: [
                "error": "\(error)"
            ])
        }
    }
}
