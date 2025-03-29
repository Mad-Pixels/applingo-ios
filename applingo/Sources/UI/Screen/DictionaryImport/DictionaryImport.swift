import UniformTypeIdentifiers
import SwiftUI

struct DictionaryImport: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding private var isPresented: Bool
    
    @StateObject private var style: DictionaryImportStyle
    @StateObject private var locale = DictionaryImportLocale()
    
    @State private var isShowingFileImporter = false
    @State private var isPressedTrailing = false
    
    /// Initializes the DictionaryImport view.
    /// - Parameters:
    ///   - isPresented: ...
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(isPresented: Binding<Bool>, style: DictionaryImportStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
        _isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            BaseScreen(
                screen: .DictionaryImport,
                title: locale.screenTitle
            ) {
                ScrollView {
                    VStack(spacing: style.spacing) {
                        DictionaryImportViewTitle(style: style, locale: locale)
                        DictionaryImportViewTable(style: style, locale: locale)
                        DictionaryImportViewDescription(style: style, locale: locale)
                        DictionaryImportViewNote(style: style, locale: locale)
                    }
                    .padding(style.padding)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ButtonNav(
                            isPressed: $isPressedTrailing,
                            onTap: { presentationMode.wrappedValue.dismiss() },
                            style: .close(themeManager.currentThemeStyle)
                        )
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [
                .plainText,
                .commaSeparatedText,
                UTType(filenameExtension: "xlsx")!
            ],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result: result)
        }
        
        DictionaryImportViewActions(
            style: style,
            locale: locale,
            onImport: {
                isShowingFileImporter = true
            }
        )
    }

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
