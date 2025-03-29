import SwiftUI

internal struct WordDetailsViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var word: DatabaseModelWord
    
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    private let ttsDisabled: Bool
    private let isEditing: Bool

    /// Initializes the WordDetailsViewMain.
    /// - Parameters:
    ///   - style: A `WordDetailsStyle` object defining the visual style of the view.
    ///   - locale: A `WordDetailsLocale` object providing localized strings.
    ///   - word: A binding to the `DatabaseModelWord` object being edited or displayed.
    ///   - isEditing: A Boolean value indicating whether editing is enabled for the view.
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
        
        self.ttsDisabled = word.wrappedValue.backText.isEmpty ||
            TTSLanguageType.shared.get(for: word.wrappedValue.backTextCode) == ""
    }

    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleWord,
                style: .block(themeManager.currentThemeStyle)
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
                    
                    Button(action: {
                        TTS.shared.speak(
                            word.backText,
                            languageCode: word.backTextCode
                        )
                    }) {
                        Image(systemName: ttsDisabled ? "speaker.slash" : "speaker.wave.2")
                            .font(.system(size: 24))
                            .foregroundColor(ttsDisabled ? style.disabledColor : style.accentColor)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                            .padding(.top, 24)
                    }
                    .disabled(
                        word.backText.isEmpty ||
                        TTSLanguageType.shared.get(for: word.backTextCode) == ""
                    )
                }
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
