import SwiftUI

internal struct DictionaryRemoteFilterViewLevel: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedLevel: DictionaryLevelType
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
    /// Initializes the DictionaryRemoteFilterViewLevel.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - selectedLevel: Binding for the selected dictionary level.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        selectedLevel: Binding<DictionaryLevelType>
    ) {
        self._selectedLevel = selectedLevel
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section() {
            SectionHeader(
                title: locale.screenSubtitleLevel,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                ItemPicker(
                    selectedValue: $selectedLevel,
                    items: DictionaryLevelType.allCases
                ) { level in
                    DynamicText(
                        model: DynamicTextModel(
                            text: level.rawValue == DictionaryLevelType.undefined.rawValue
                            ? locale.screenTextUFOLevel : level.rawValue
                        ),
                        style: .textMain(themeManager.currentThemeStyle)
                    )
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
