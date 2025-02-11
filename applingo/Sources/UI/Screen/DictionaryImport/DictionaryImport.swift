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
    @Binding private var isPresented: Bool
    
    // MARK: - Initializer
    
    /// Initializes the DictionaryImport view.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(isPresented: Binding<Bool>, style: DictionaryImportStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _isPresented = isPresented
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            BaseScreen(
                screen: .DictionaryImport,
                title: locale.screenTitle
            ) {
                ScrollView {
                    VStack(spacing: style.spacing) {
                        DictionaryImportViewTitle(locale: locale, style: style)
                        DictionaryImportViewTable(locale: locale, style: style)
                        DictionaryImportViewDescription(locale: locale, style: style)
                        DictionaryImportViewNote(locale: locale, style: style)
                    }
                    .padding(style.padding)
                }
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
            guard let sourceURL = urls.first else { return }
            
            guard sourceURL.startAccessingSecurityScopedResource() else {
                return
            }
            
            defer {
                sourceURL.stopAccessingSecurityScopedResource()
            }
            
            let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(sourceURL.lastPathComponent)
            
            try? FileManager.default.removeItem(at: temporaryFileURL)
            do {
                try FileManager.default.copyItem(at: sourceURL, to: temporaryFileURL)
                
                let parser = DictionaryParser()
                Task {
                    defer {
                        try? FileManager.default.removeItem(at: temporaryFileURL)
                    }
                    
                    do {
                        try await withCheckedThrowingContinuation { continuation in
                            parser.importDictionary(from: temporaryFileURL) { result in
                                continuation.resume(with: result)
                            }
                        }
                        await MainActor.run {
                            isPresented = false
                        }
                    } catch {}
                }
            } catch {}
        case .failure:
            break
        }
    }
}
