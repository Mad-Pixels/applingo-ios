import SwiftUI

struct DictionaryImport: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryImportStyle
    @StateObject private var locale = DictionaryImportLocale()
    
    // Флаг, управляющий показом системного диалога выбора файла
    @Binding var isShowingFileImporter: Bool
    
    // Флаг для анимации нажатия на кнопку (для ButtonNav).
    @State private var isPressedTrailing = false
    
    // Инициализатор
    init(
        isShowingFileImporter: Binding<Bool>,
        style: DictionaryImportStyle? = nil
    ) {
        self._isShowingFileImporter = isShowingFileImporter
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryImport,
            title: locale.navigationTitle
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
        
        // Кнопка, по нажатию показываем диалог выбора файла
        ButtonAction(
            title: locale.importCSVTitle,
            action: {
                isShowingFileImporter = true
            },
            style: .action(ThemeManager.shared.currentThemeStyle)
        )
        
        // Собственно диалог выбора файла (.fileImporter)
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [
                .plainText,
                .commaSeparatedText
                // Если нужен TSV, можно добавить .tabSeparatedText (iOS 15+).
            ],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let fileURL = urls.first else {
                    Logger.debug("[DictionaryImportView]: No file selected")
                    return
                }
                
                // Вызываем парсер
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
}
