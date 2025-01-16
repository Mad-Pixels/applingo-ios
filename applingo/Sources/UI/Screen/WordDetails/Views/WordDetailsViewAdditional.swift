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
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.additionalTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
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
                    icon: "scroll"
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
