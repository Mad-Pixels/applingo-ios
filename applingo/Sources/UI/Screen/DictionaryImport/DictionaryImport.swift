import SwiftUI


struct DictionaryImport: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryImportStyle
    @StateObject private var locale = DictionaryImportLocale()
    
    @Binding var isShowingFileImporter: Bool
    @State private var isPressedTrailing = false
    
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
            screen: .dictionariesLocal,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryImportViewColumns(
                        locale: locale,
                        style: style
                    )
                    
                    DictionaryImportViewExamples(
                        locale: locale,
                        style: style
                    )
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
        
        ButtonAction(
            title: "locale.importTitle",
            action: showImporter,
            style: .action(ThemeManager.shared.currentThemeStyle)
        )
    }
    
    private func showImporter() {
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isShowingFileImporter = true
        }
    }
}
