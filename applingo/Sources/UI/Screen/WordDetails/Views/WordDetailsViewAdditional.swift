import SwiftUI

struct WordDetailsViewAdditional: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: DatabaseModelWord
    let tableName: String
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    let isEditing: Bool
    
    init(
        word: Binding<DatabaseModelWord>,
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
                    title: locale.tableNamePlaceholder.capitalizedFirstLetter,
                    placeholder: locale.tableNamePlaceholder,
                    isEditing: false
                )
                
                InputText(
                    text: Binding(
                        get: { word.hint ?? "" },
                        set: { word.hint = $0.isEmpty ? nil : $0 }
                    ),
                    title: locale.hintPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.hintPlaceholder,
                    isEditing: isEditing
                )
                
                InputTextArea(
                    text: Binding(
                        get: { word.description ?? "" },
                        set: { word.description = $0.isEmpty ? nil : $0 }
                    ),
                    title: locale.descriptionPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.descriptionPlaceholder,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
