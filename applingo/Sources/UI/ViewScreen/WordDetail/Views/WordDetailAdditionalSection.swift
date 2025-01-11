import SwiftUI

struct WordDetailAdditionalSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: WordItemModel
    let tableName: String
    private let locale: ScreenWordDetailLocale
    private let style: ScreenWordDetailStyle
    let isEditing: Bool
    
    init(
        word: Binding<WordItemModel>,
        tableName: String,
        locale: ScreenWordDetailLocale,
        style: ScreenWordDetailStyle,
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
                TextInput(
                    text: .constant(tableName),
                    placeholder: locale.tableNamePlaceholder,
                    isEditing: false
                )
                
                TextInput(
                    text: Binding(
                        get: { word.hint ?? "" },
                        set: { word.hint = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: locale.hintPlaceholder,
                    isEditing: isEditing,
                    icon: "tag"
                )
                
                TextArea(
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
