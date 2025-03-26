import SwiftUI

struct WordDetailsViewMain: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
        
    @Binding var word: DatabaseModelWord
    private let isEditing: Bool
    
    // MARK: - Initializer
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: Binding<DatabaseModelWord>,
        isEditing: Bool
    ) {
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
        self._word = word
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleWord,
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)

            VStack(spacing: style.spacing) {
                InputText(
                    text: $word.frontText,
                    title: locale.screenDescriptionFrontText,
                    placeholder: "",
                    isEditing: isEditing
                )

                HStack {
                    InputText(
                        text: $word.backText,
                        title: locale.screenDescriptionBackText,
                        placeholder: "",
                        isEditing: isEditing
                    )
                    
                    // Кнопка озвучивания с использованием TTS сервиса
                    Button(action: {
                        // Используем наш TTS сервис
                        TTS.shared.speak(word.backText, language: "en-US")
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .font(.system(size: 20))
                            .foregroundColor(themeManager.currentThemeStyle.accentPrimary)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .disabled(word.backText.isEmpty)
                }
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
