import SwiftUI

struct WordDetailsViewAdditional: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: WordItemModel
    let tableName: String
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    let isEditing: Bool
    
    init(
        word: Binding<WordItemModel>,
        tableName: String,
        locale: WordDetailsLocale,
        style: WordDetailsStyle,
        isEditing: Bool
    ) {
        self._word = word
        self.tableName = tableName
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
    }
    
    var body: some View {
        Section(header: Text(locale.additionalTitle)) {
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(tableName),
                    placeholder: locale.tableNamePlaceholder,
                    isEditing: false
                )
                
                InputText(
                    text: Binding(
                        get: { word.hint ?? "" },
                        set: { word.hint = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: locale.hintPlaceholder,
                    isEditing: isEditing,
                    icon: "tag"
                )
                
                InputTextArea(
                    text: Binding(
                        get: { word.description ?? "" },
                        set: { word.description = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: locale.descriptionPlaceholder,
                    isEditing: isEditing,
                    border: true,
                    icon: "scroll"
                )
            }
            .padding(style.padding)
        }
    }
}
